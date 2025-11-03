#import "@preview/polylux:0.4.0": slide as polylux-slide, toolbox
#import "@preview/subpar:0.2.2"

#let m-dark-teal = rgb("#23373b")
#let m-light-brown = rgb("#eb811b")
#let m-lighter-brown = rgb("#d6c6b7")
#let m-extra-light-gray = white.darken(2%)

#let ovgu-red = rgb("#D13F58")
#let ovgu-purple = rgb("#7A003F")
#let ovgu-blue = rgb("#0068B4")
#let ovgu-darkgray = rgb("#606060")
#let ovgu-lightgray = rgb("#C0C0C0").lighten(50%)
#let ovgu-orange = rgb("#F39100")

#let m-pages = counter("m-page")
#let m-footer = state("m-footer", [])
#let m-metadata = state("m-metadata", (:))

#let ams-logo =  image("AMS.pdf", height: 4cm)
#let kmd-logo =  image("KMD.pdf", height: 4cm)
#let header-logo = image("AMSKMDhead.pdf", height: 116%)

#let ovgu-inf-blue = rgb(0, 104, 180)

/* ----- General theming and show rules ----- */

#let ams-theme(aspect-ratio: "16-9", text-size: 10pt, body) = {
  set page(
    width: 160mm,
    height: 90mm,
    margin: 0em,
  )

  set text(font: "Latin Modern Sans", fill: m-dark-teal, text-size)
  set list(indent: 1em)
  set enum(indent: 1em)
  
  show raw: set text(font: "New Computer Modern Sans", 1.1em)

  // Add line numbers to code block.
  show raw.where(block: true): r => {
    show raw: set par(leading: 0.75em)
    show raw.line: l => {
      box(table(
        columns: (-1.25em, 100%),
        stroke: 0pt,
        inset: 0em,
        column-gutter: 1em,
        align: (x, y) => if x == 0 { right } else { left },
        text(fill: ovgu-darkgray, str(l.number)),
        l.body,
      ))
    }

    set align(left)
    block(width: 100%, stroke: gray + 0.5pt, inset: 0.75em, r)
  }

  // Display supplement in bold.
  show figure.caption: c => context [
    *#c.supplement #c.counter.display(c.numbering)#c.separator*#c.body
  ]

  // Make URLs use monospaced font.
  show link: it => { set text(font: "New Computer Modern Sans", 0.9em) if type(it.dest) == str; it }

  // set footnote.entry(
  //   indent: 2.5em,
  //   separator: line(start: (2em, 0em), end: (40%, 0em), stroke: 0.5pt),
  // )
  // v(-1cm)
  body
}

// Declare your title slide! OvGU logo to the right.
//
// - title: Your presentation title.
// - author: Consists of author.name and author.mail.
// - subtitle: (Optional) subtitle for more info.
// - short-title: (Optional) short title for the footer.
// - logo: (Optional) institution / faculty logo
// - date: (Optional) date of the presentation.
// - extra: (Optional) info below the date, like your faculty.
// - backdrop-logo: (Optional) institution / faculty mascot.
#let title-slide(
  title: [],
  author: (name: "Your name", mail: "example@ovgu.de"), 
  subtitle: none, 
  short-title: none,
  logo: none,
  date: datetime.today().display("[day].[month].[year]"), 
  extra: none,
  backdrop-logo: none,
) = {
  m-metadata.update(("title": title, "authors": author))
  
  let content = {
    // Blue rectangle header with OvGU head and logo.
    rect(fill: ovgu-inf-blue, width: 100%, height: 90mm-55mm, inset: (left: 14mm, rest: 0mm))[
      #place(top + right, backdrop-logo)
      #place(top + left, dy: 3mm,  logo)
    ]
    // Title, subtitle and author data.
    place(bottom + left, dx: 14mm, dy: -60mm)[
      #set text(white)
      #text(14pt, strong(title))
      #v(1em, weak: true)
      #text(10pt, strong(subtitle))
    ]
    place(top + left, dx: 14mm, dy: 90mm-50mm)[
      #let wide-lmmodern = text.with(font: "Latin Modern Sans 8")
      #stack(dir: ttb, spacing: 5mm, strong(author.name), wide-lmmodern(extra, 7pt), wide-lmmodern(date, 8pt))
    ]
    // AMS + KMD logo.
    place(bottom + right, dx: -10mm, dy: -7mm)[
      #stack(dir: ltr, spacing: 5mm,
        image("KMD.pdf", height: 20mm),
        image("AMS.pdf", height: 20mm)
      )
    ]
  }

  // let insertable = if short-title != none { short-title } else { title }
  // m-footer.update(
  //   grid(columns: (1fr, auto), align: (left, center), 
  //     if type(author) == array { h(1cm) + insertable + "  |  " + author.map(x => x.name).join(", ") } else { h(1cm) + insertable + "  |  " + author.name }, 
  //     context [#m-pages.get().first() / #m-pages.final().first()] + h(1cm)
  //   ),
  // )
  
  polylux-slide(content)
}

// Basic slide function.
//
// - title: (Optional) title of the slide, will be shown on the left in the header.
// - new-section: (Optional) marks a new topic, adds it to the outline & on the right in the header.
// - show-current-section: (default: true) if the current section should be displayed.
// - show-footer: (default: true) if the footer should be displayed.
// - skip: (default: false) whether to skip the page counter for this slide
#let slide(
  title: none,
  new-section: none,
  show-current-section: true,
  show-footer: true,
  skip: false,
  body,
) = {
  // Define header: [Subsection] --- [Section], incl. progress bar.
  let header = {
    set align(top)
    
    if title != none {
      if new-section != none {
        toolbox.register-section(new-section)
      }

      if not skip {
        m-pages.step()
      }
      block(header-logo, width: 100%)

      v(-2.8cm)
      block(inset: 1em, width: 100%, height: 100%)[
        #set align(left)
        #set text(fill: ovgu-blue, 1.4em)
        *#title*#h(1fr)

      ]
    } else {
      strong("Missing Headline")
    }

    //block(height: 1pt, width: 100%, spacing: 0pt, m-progress-bar)
  }

  // Define footer: [author] - [title] - [page / total]
  let footer = if show-footer {
    v(-0.4cm)
    block(fill: ovgu-blue, height: 1.3em, align(horizon, text(0.8em, fill: white, context m-footer.get()))) 
  }

  set page(
    header: header,
    footer: footer,
    header-ascent: 0em,
    margin: (top: 2.5em, bottom: 1em),
    fill: white,
  )

  let content = {
    show: align.with(horizon)
    show: pad.with(2em)
    body
  }

  polylux-slide(content)
}

/* ----- Helper / Utility functions for tables, subfigures, shortcuts & todos. ----- */

// Creates a clickable outline with a customizable title for each `new-section` entry.
// - `show-title`: Whether to show the presentation title as a heading (default: false)
// - `new-section`: The next section to highlight in the outline-slide (default: none)
#let outline-slide(title: "Outline", show-title: false, new-section: none) = slide(
  title: title, 
  show-footer: false, 
  skip: true,
  [
    #set list(marker: none, spacing: 2em)
    #set text(gray) if new-section != none

    #if show-title [
      - #text(m-dark-teal, context m-metadata.get().title)
    ]

    - #toolbox.all-sections((s, c) => list(
        ..s.map(x => if x.body.text == new-section { text(m-dark-teal, x) } else { x })
      ))
  ]
)

// Creates a list of all references using the given style.
#let bib-slide(title: "References", bibliography) = slide(
  title: title, 
  show-footer: false, 
  show-current-section: false, 
  skip: true
)[
  #set grid(align: top)
  #set par(justify: true)
  #set text(0.9em)
  #bibliography
]

// Custom ParCIO table as illustrated in the template.
#let ams-table(max-rows, ..args) = table(
  ..args,
  row-gutter: (2.5pt, auto),
  stroke: (x, y) => (
    left: 0.5pt,
    right: 0.5pt,
    top: if y <= 1 { 0.5pt },
    bottom: if y == 0 or y == max-rows - 1 { 0.5pt }
  )
)

// Simple orange TODO box.
#let todo = rect.with(fill: ovgu-orange, stroke: black + 0.5pt, radius: 0.25em, width: 100%)
