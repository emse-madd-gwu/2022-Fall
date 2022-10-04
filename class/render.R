lesson <- strsplit(here::here(), "/")[[1]]
lesson <- lesson[length(lesson)]

# Build the slides
renderthis::to_html("index.Rmd", "index.html")
renderthis::to_pdf("index.html", paste0(lesson, ".pdf"))

# Create zip files of class notes
zip::zip(
    zipfile = paste0(lesson, ".zip"),
    files = c(
        'data',
        'p2-choice-questions-table.Rmd',
        'p2-choice-questions.Rmd',
        'make_choice_questions.R',
        'images',
        paste0(lesson, ".Rproj")))
