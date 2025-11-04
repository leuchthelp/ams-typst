#import "../src/ams.typ": *
#show: ams-theme

#title-slide(
  title: "Full Title of the Presentation",
  subtitle: "Subtitle if necessary",
  extra: [
    Title of Course\
    Faculty of Computer Science\
    Otto von Guericke University Magdeburg
  ],
)

// Show presentation title in outline and highlight upcoming section.
#outline-slide(show-title: true, new-section: "Introduction")

/* ---------- */

#slide(title: "Template", new-section: "Introduction")[
  = Heading 1
  
  You can use the usual Typst markup syntax such as headings.

  You can change or add certain stylistic choices -- let's number the headings:\
  ```typ #set heading(numbering: "1.1")```

  #set heading(numbering: "1.1")

  == Subheading 2
  
  - This level 2 subheading is now numbered as `0.1` since the one before is not numbered.
    - Either apply set rules globally or locally within a slide scope.
    
  - This presentation template is available at https://github.com/leuchthelp/ams-typst
    and consists of the Typst template and some example code.
]

#slide(
  title: "Figures",
  alignment: horizon,
)[
  - You can refer to the subfigures (Figures @fig1a[] and @fig1b[]) or the figure (@fig1).
    - _(this slide is horizontally centered!)_
    
  #subpar.grid(
    caption: "Two OvGU logos next to each other.", 
    columns: 2,
    label: <fig1>,
    figure(caption: "Left")[
      #image(alt: "Blue OVGU logo", width: 75%, "ovgu.pdf")
    ],<fig1a>,
    figure(caption: "Right")[
      #image(alt: "Blue OVGU logo", width: 75%, "ovgu.pdf")
    ],<fig1b>
  )
]

#slide(
  title: "Literature, Tables, etc...",
  new-section: "References",
)[
  - You can comfortably reference literature @DuweLMSF0B020 @10706368 @9841364
  - You can also refer to tables (@tbl) #footnote[This is a footnote.]
  
  #figure(caption: "A basic table.", table(columns: 3, stroke: .75pt,
    table.header([*Header 1*], [*Header 2*], [*Header 3*]),
    [Row 1], [Row 1], [Row 1],
    [Row 2], [Row 2], [Row 2],
    [Row 3], [Row 3], [Row 3],
  ))<tbl>

  - Next, some math...
]

#slide(
  title: "Math",
)[
  = Math is also referenceable! (with numbering)

  $ (partial T) / (partial x)(0, t) = (partial T) / (partial x)(L, t) = 0\ "where" forall t > 0 "with" L = "length". $<eq>

  See @eq for a _(numbered)_ reference to an equation.

  We can also do math inline: $pi approx 22 / 7 approx 3$ or some simple plotting.

  #import "@preview/lilaq:0.5.0" as lq
  #lq.diagram(
    width: 10cm,
    height: 2cm,
    lq.plot(lq.linspace(0, 2 * calc.pi), x => calc.sin(x))
  )
]

#slide(title: "Listings")[
  = Code blocks (similar to Markdown)

  #figure(caption: "Some simple C code.")[
    ```c
    printf("Hello World\n");

    // Comment
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            sum += 'a';
        }
    }
    ```
  ]<lst>

  - You can also refer to listings (@lst) and use `inline code`!
]

#slide(title: "Columns", new-section: "Extras", alignment: horizon)[
  = Multi-Column Environment

  #grid(columns: (1fr, 1fr), column-gutter: 1em)[
    - Slides can be split into columns

    - See the `grid` function for more information on customization
  ][
    ```c
    printf("Hello World\n");

    // Comment
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            sum += 'a';
        }
    }
    ```
  ]
]

#slide(title: "Todos")[
  #todo[*FIXME:* You can add todo notes here!]
  #lorem(125)
]

#bib-slide(bibliography(
  "bibliography/report.bib",
   title: none,
   style: "ieee"
))
