# Load class settings & functions
source(here::here("R", "settings.R"))

schedule <- get_schedule()

# Starting content string
start <-
'project:
  type: website
  output-dir: _site
  preview:
    port: 5896
    browser: true
  render:
    - "*.qmd"
    - "!fragments/"

website:
  title: "{{< var number >}}"
  image: images/logo.png
  site-url: "{{< var site_url >}}"
  favicon: images/favicon.ico
  repo-url: "{{< var repo >}}"
  description: \'Course website for {{< var semester >}} semester of the EMSE course {{< var name >}} at GWU\'
  search:
    location: navbar
    type: overlay
    copy-button: true
  open-graph:
    locale: es_ES
    site-name: "{{< var root_url >}}"
  twitter-card:
    creator: "@johnhelveston"
    site: "@johnhelveston"
    image: "images/logo-square.png"
    card-style: summary
  navbar:
    background: primary
    left:
      - text: Home
        href: index.qmd
      - text: Syllabus
        href: syllabus.qmd
      - text: "Schedule"
        href: schedule.qmd
      - text: Class
        menu:'

# Class class string
class <- schedule %>% 
    mutate(
        text = paste0(
            '        - text: "', format(date, "%b %d"), ": ", name, '"' 
        ), 
        href = paste0(
            "          href: ", "class/", class_stub, ".qmd\n"
        ),
        href = ifelse(is.na(stub), "", href), 
        class = paste(text, href, sep = "\n")
    )
class <- class$class
class <- paste0(class, collapse = "")
# Remove last "\n"
class <- str_sub(class[length(class)], 1, -2)

# Assignment string
assignment <- schedule %>%
    filter(!is.na(assign_due)) %>% 
    mutate(
        text = paste0(
            '        - text: "', format(date, "%b %d"), ": ", assign_name,
            " (Due ", assign_due, ')"'
        ), 
        href = paste0(
            "          href: ", "hw/", assign_stub, ".qmd\n"
        ),
        href = ifelse(is.na(assign_stub), "", href), 
        assignment = paste(text, href, sep = "\n")
    )
assignment <- assignment$assignment
# Insert primer assignment
assignment <- c(
'        - text: "Self Assessment (optional)"
          href: hw/0-self-assessment.qmd
',
    assignment
)
assignment <- paste0(assignment, collapse = "")
# Remove last "\n"
assignment <- str_sub(assignment[length(assignment)], 1, -2)

# Final projects string
final <- schedule %>%
    filter(!is.na(project_final)) %>% 
    mutate(
        text = paste0(
            "        - text: ", final_name, " (Due ", final_due, ")"
        ), 
        href = paste0(
            "          href: ", "project-final/", final_stub, ".qmd\n"
        ),
        final = paste(text, href, sep = "\n")
    )
final <- final$final
# Insert project overview
final <- c(
    '        - text: "Project Overview"
          href: project-final/0-overview.qmd
',
    final
)
final <- paste0(final, collapse = "")
# Remove last "\n"
final <- str_sub(final[length(final)], 1, -2)

# Help string 
help <- 
'      - text: Help
        menu:
        - text: Schedule a call w/Prof. Helveston
          href: https://jhelvy.appointlet.com/b/professor-helveston
        - text: Course Software
          href: help/course-software.qmd
        - text: Getting Help
          href: help/getting-help.qmd
        - text: Example Projects
          href: help/example-projects.qmd
        - text: Finding Data
          href: help/finding-data.qmd
        - text: Visualizing Data
          href: help/visualizing-data.qmd
        - text: Programming in R
          href: help/programming.qmd
        - text: R Markdown
          href: help/rmarkdown.qmd
        - text: Other
          href: help/other.qmd'

# End content string
end <-
'      - icon: slack
        href: "{{< var slack >}}"
    right:
    - icon: list
      menu:
      - text: About
        href: about.qmd
      - text: License
        href: LICENSE.qmd
      - text: Contact
        href: mailto:jph@gwu.edu
      - icon: github
        href: "{{< var repo >}}"
  page-footer:
    center:
      - text: \'{{< var title >}} <br><i class="far fa-calendar-alt"></i> {{< var weekday >}} | <i class="far fa-clock"></i> {{< var time >}} | <a href="{{< var room_url >}}"><i class="fa fa-map-marker-alt"></i> {{< var room >}}</a> | <a href="https://www.jhelvy.com"><i class="fas fa-user"></i> Dr. John Paul Helveston</a> | <a href="mailto:jph@gwu.edu"><i class="fas fa-envelope"></i> jph@gwu.edu</a> | <a href="{{< var repo >}}"><i class="fab fa-github"></i></a>\'

format:
  html:
    theme: united
    css: styles.css
    anchor-sections: true
    smooth-scroll: true
    link-external-newwindow: true
    include-in-header: "_includes/header.html"'

# Combine
yml <- c(
    start, 
    class,
    '      - text: "Assignments"
        menu:',
    assignment, 
    '      - text: "Final Project"
        menu:',
    final,
    help,
    end,
    collapse = ""
)

# Write _quarto.yml file
fileConn <- file("_quarto.yml")
writeLines(yml, fileConn)
close(fileConn)
