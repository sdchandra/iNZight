## --------------------------------------------
## The super class for the plot modification window
## The different windows that are opened through the
## 'Inference Information' button are subclasses of this superclass
## The window that is opened depends on the variables
## currently selected in the control widget (or in the iNZDocument,
## which is the same since the two are linked together)
## --------------------------------------------

iNZPlotInfWin <- setRefClass(
    "iNZPlotInfWin",
    fields = list(
        GUI = "ANY",
        modWin = "ANY",        
        tbl = "ANY"
        ),
    methods = list(
        initialize = function(gui=NULL) {
            initFields(GUI = gui)
            if (!is.null(GUI)) {
                modWin <<- gwindow(title = "Add Inference Info",
                                   visible = TRUE,
                                   parent = GUI$win)
                mainGrp <- ggroup(horizontal = FALSE,
                                  container = modWin,
                                  expand = FALSE)
                mainGrp$set_borderwidth(15)
                tbl <<- glayout(cont = mainGrp,
                                spacing = 20)
                lbl1 <- glabel("Choose Parameter:")
                font(lbl1) <- list(weight="bold",
                                   family = "normal",
                                   size = 11)
                lbl2 <- glabel("Interval Type:")
                font(lbl2) <- list(weight="bold",
                                   family = "normal",
                                   size = 11)
                lbl3 <- glabel("Methods to use:")
                font(lbl3) <- list(weight="bold",
                                   family = "normal",
                                   size = 11)
                tbl[1, 1, expand = TRUE, anchor = c(-1, 0)] <<- lbl1
                tbl[2, 1, expand = TRUE, anchor = c(-1, 0)] <<- lbl2
                tbl[3, 1, expand = TRUE, anchor = c(-1, 0)] <<- lbl3
            }
        })
    )

iNZBarchartInf <- setRefClass(
    "iNZBarchartInf",
    contains = "iNZPlotInfWin",
    methods = list(
        initialize = function(gui) {
            callSuper(gui)
            intType <- gradio(c("Comparison Intervals",
                                "Confidence Intervals",
                                "Comparison + Confidence Intervals"),
                              selected = 1)
            mthd <- gradio(c("Bootstrap", "Normal"),
                           selected = 2)
            addButton <- gbutton(
                "Add Intervals",
                handler = function(h, ...) {
                    inf.type <- list("comp",
                                     "conf",
                                     c("comp", "conf"))[[svalue(intType,
                                                                index = TRUE)]]
                    bs.inf <- svalue(mthd, index = TRUE) == 1
                    GUI$getActiveDoc()$setSettings(
                        list(
                            inference.type = inf.type,
                            bs.inference = bs.inf
                            )
                        )
                })
            tbl[1, 2, expand = TRUE, anchor = c(-1, 0)] <<- glabel("Proportions")
            tbl[2, 2] <<- intType
            tbl[3, 2] <<- mthd
            tbl[4, 2, expand = TRUE, anchor = c(1, -1)] <<- addButton
        })
    )
            
iNZDotchartInf <- setRefClass(
    "iNZDotchartInf",
    contains = "iNZPlotInfWin",
    methods = list(
        initialize = function(gui) {
            callSuper(gui)
            parm <- gradio(c("Medians",
                             "Means"))
            intType <- gradio(c("Comparison Intervals",
                                "Confidence Intervals",
                                "Comparison + Confidence Intervals"))
            mthd <- gradio(c("Bootstrap", "Year 12"),
                           selected = 2)            
            addButton <- gbutton("Add Intervals")
            tbl[1, 2] <<- parm
            tbl[2, 2] <<- intType
            tbl[3, 2] <<- mthd
            tbl[4, 2, expand = TRUE, anchor = c(1, -1)] <<- addButton
        })
    )