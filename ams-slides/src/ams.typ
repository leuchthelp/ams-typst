#import "@preview/polylux:0.4.0": slide as polylux-slide, toolbox
#import "@preview/subpar:0.2.2"

#let m-dark-teal = rgb("#23373b")
#let ovgu-darkgray = rgb("#606060")
#let ovgu-orange = rgb("#F39100")
#let ovgu-inf-blue = rgb(0, 104, 180)

#let m-footer = state("m-footer", [])
#let m-metadata = state("m-metadata", (:))

#let ams-logo = image("AMS.pdf", height: 20mm)
#let kmd-logo = image("KMD.pdf", height: 20mm)
#let university-logo = image("Signet_INF_1_inv.pdf", height: 11mm)
#let backdrop-logo = image("otto.pdf")
#let header-logo = image("AMSKMDhead.pdf", width: 100%)

/* ----- General theming and show rules ----- */

/// A show-rule to apply general AMS theming rules.
/// 
/// By default, this will set the slide dimensions to (160mm x 90mm)
/// and the text size to 10pt -- this is configurable.
///
/// -> content
#let ams-theme(
  width: 160mm,
  height: 90mm,
  text-size: 10pt,
  body
) = {
  set page(
    width: width,
    height: height,
    margin: 0mm,
  )

  set text(font: "Latin Modern Sans", fill: m-dark-teal, text-size)
  set math.equation(numbering: "(1)")

  set figure(gap: 1em)
  set list(indent: 1em)
  set enum(indent: 1em)
  
  show heading: set block(spacing: 1em)
  show raw: set text(font: "DejaVu Sans Mono")
  show link: it => { set text(font: "DejaVu Sans Mono", .8em) if type(it.dest) == str; it }

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

  show footnote.entry: it => it + v(5pt)
  set footnote.entry(
    indent: 1cm,
    separator: line(start: (1cm, 0em), end: (40%, 0em), stroke: 0.5pt),
  )
  
  body
}

/// The title slide of your presentation.
///
/// ```example 
/// #title-slide(
///   title: "My presentation about Typst",
///   author: (name: "Peter Trom", mail: "example@ovgu.de"),
///   subtitle: "A subtitle to ascertain the importance of my topic"
/// )
/// ```
/// 
/// -> content
#let title-slide(
  /// The title of your presentation.
  /// -> content | none
  title: none,
  /// The author data (name and mail).
  /// -> dictionary
  author: (name: "Your name", mail: "example@ovgu.de"),
  /// An optional subtitle.
  /// -> content | none
  subtitle: none,
  /// An optional shorter title for the footer.
  /// -> content | none
  short-title: none,
  /// The current date and formatting (default: `datetime.today()`).
  /// -> datetime
  date: datetime.today().display("[day].[month].[year]"),
  /// Extra data such as course title, institute or university.
  /// -> content | none
  extra: none,
  /// The university logo in the top left of the title slide.
  /// -> content
  university-logo: university-logo,
  /// The backdrop logo in the top right of the title slide.
  /// -> content
  backdrop-logo: backdrop-logo,
  /// The insititute logos as an array in the bottom right of the title slide.
  /// -> array
  institute-logos: (kmd-logo, ams-logo),
) = {
  m-metadata.update(("title": title, "authors": author))
  
  let content = {
    // Blue rectangle header with OvGU head and logo.
    rect(fill: ovgu-inf-blue, width: 100%, height: 90mm-55mm, inset: (left: 14mm, rest: 0mm))[
      #place(top + right, backdrop-logo)
      #place(top + left, dy: 3mm,  university-logo)
    ]
    // Title, subtitle and author data.
    place(bottom + left, dx: 14mm, dy: -60mm)[
      #set text(white)

      #show std.title: set text(14pt, weight: "bold")
      #show std.title: set block(below: 0.7em)
      
      #std.title(title)
      #text(10pt, strong(subtitle))
    ]
    place(top + left, dx: 14mm, dy: 90mm-50mm)[
      #let wide-lmmodern = text.with(font: "Latin Modern Sans 8")
      #stack(dir: ttb, spacing: 5mm, strong(author.name), wide-lmmodern(extra, 7pt), wide-lmmodern(date, 8pt))
    ]
    // AMS + KMD logo.
    place(bottom + right, dx: -10mm, dy: -7mm)[
      #stack(dir: ltr, spacing: 5mm,
        ..institute-logos
      )
    ]
  }

  let footer-title = if short-title != none { short-title } else { title }
  m-footer.update(
    grid(columns: (1fr, 1fr), align: (left, right), 
      footer-title + " | " + author.name, 
      toolbox.slide-number + "/" + toolbox.last-slide-number
    ),
  )
  
  polylux-slide(content)
}

/// The basic slide function to create a new slide.
///
/// ```example
/// #slide(title: "Introduction")[My slide content!]
/// ``` 
/// 
/// -> content
#let slide(
  /// The slide title, displayed in the upper left of the header.
  /// -> content | none
  title: none,
  /// A new section title, displayed in the outline slide.
  /// -> content | none
  new-section: none,
  /// The header logo / bar, default is KMD+AMD.
  /// -> content
  header-logo: header-logo,
  /// The current slide alignment (default: top + left).
  /// -> alignment
  alignment: top + left,
  /// Whether to show the footer bar (default: true).
  /// -> bool
  show-footer: true,
  /// Whether to skip the page counter for this slide (default: false).
  /// -> bool
  skip: false,
  body,
) = {
  let header = {
    block(header-logo, width: 100%)

    if title != none {
      if new-section != none {
        toolbox.register-section(new-section)
      }
      
      if skip {
        counter("logical-slide").update(n => n - 1)
      }
      
      place(bottom + left, dx: 4mm, dy: -5mm)[
        #set text(fill: ovgu-inf-blue, 12pt)
        *#title*
      ]
    }
  }

  let footer = if show-footer {
    block(fill: ovgu-inf-blue, width: 100%, height: 100%, inset: (x: .5cm))[
      #set text(white, 4pt)
      #set align(horizon)
      *#context m-footer.get()*
    ] 
  }

  set page(
    header: header,
    footer: footer,
    header-ascent: 0mm,
    footer-descent: 0mm,
    margin: (top: 1.1cm, bottom: .3cm),
    fill: white,
  )

  let content = {
    show: align.with(alignment)
    show: pad.with(x: 1cm, y: .5cm)

    // Slightly adjust content if horizontal alignment is selected
    // to account for the different margin sizes of the page.
    let adjusted-body = context if alignment == horizon {
      let move-diff = (page.margin.top - page.margin.bottom) / 2
      move(dy: -move-diff, body)
    } else {
      body
    }
    
    adjusted-body
  }

  polylux-slide(content)
}

/* ----- Helper / Utility functions for tables, subfigures, shortcuts & todos. ----- */

/// Creates a clickable outline with a customizable title for each `new-section` entry.
///
/// -> content
#let outline-slide(
  /// The title of the slide in the top left.
  /// -> string | content
  title: "Outline",
  /// Whether to show the presentation title as a heading (default: false)
  /// -> bool
  show-title: false,
  /// The next section to highlight in the outline-slide (default: none)
  /// -> string | none
  new-section: none
) = slide(
    title: title, 
    alignment: horizon,
    show-footer: false, 
    skip: true
  )[
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

/// Creates a list of all references using the given style.
#let bib-slide(title: "References", bibliography) = slide(title: title)[
  #set grid(align: top)
  #set par(justify: true)
  #set text(0.9em)
  #bibliography
]

/// Simple orange TODO box.
#let todo = rect.with(fill: ovgu-orange, stroke: black + 0.5pt, radius: 0.25em, width: 100%)
