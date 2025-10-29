#import "@local/ams-slides:0.0.1": *
#show: ams-theme

#title-slide(
  title: "Full Title of the Presentation",
  subtitle: "Subtitle if necessary",
  logo: image("Signet_INF_1_inv.svg", width: auto, height: 2cm),
  extra: [
    #set text(0.825em)
    Title of Course\
    Faculty of Computer Science\
    Otto von Guericke University Magdeburg
  ],
  backdrop-logo: image("otto.svg", width: auto, height: 7cm),
)

// Show presentation title in outline and highlight upcoming section.
#outline-slide(show-title: true, new-section: "Introduction")

/* ---------- */


#slide(title: "Template", new-section: "Introduction")[
  - This presentation template is available at
    https://github.com/xkevio/parcio-typst and consists of Sections 1 to 4.
]

#slide(
  title: "Figures",
)[
  #subpar.grid(
    caption: "Test", 
    columns: 2,
    label: <fig1>,
    figure(caption: "Left")[
      #image(alt: "Blue OVGU logo", width: 75%, "ovgu.svg")
    ],<fig1a>,
    figure(caption: "Right")[
      #image(alt: "Blue OVGU logo", width: 75%, "ovgu.svg")
    ],<fig1b>
  )
  \
  - You can refer to the subfigures (Figures @fig1a[] and
    @fig1b[]) or the figure (@fig1).
]

#slide(
  title: "References",
  new-section: "Background",
)[
  - You can comfortably reference literature @DuweLMSF0B020 #footnote[This is a footnote.]
]

#slide(title: "Tables")[
  // You can also create normal tables with `#table`,
  // this one just has some styling preapplied.
  #figure(caption: "Caption", ams-table(4, columns: 3,
    [*Header 1*], [*Header 2*], [*Header 3*],
    [Row 1], [Row 1], [Row 1],
    [Row 2], [Row 2], [Row 2],
    [Row 3], [Row 3], [Row 3],
  ))<tbl>

  - You can also refer to tables (@tbl)
]

#slide(
  title: "Math",
)[
  $ (diff T) / (diff x)(0, t) = (diff T) / (diff x)(L, t) = 0\ "where" forall t > 0 "with" L = "length". $

  \

  #figure(caption: "Lots of fun math!", kind: math.equation)[
    $&sum_(k = 0)^n pi dot k \
    <=> &sum_(k = 1)^n pi dot k \
    <=> &sum_(k = 2)^n (pi dot k) + pi
    $
  ]
]

#slide(title: "Listings", new-section: "Evaluation")[
  #figure(caption: "Caption")[
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

#slide(title: "Columns")[
  #grid(columns: (1fr, 1fr), column-gutter: 1em)[
    - Slides can be split into columns
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

#slide(title: "Todos", new-section: "Conclusion")[
  #todo("FIXME")
  #lorem(125)
]

#bib-slide(bibliography(
  "bibliography/report.bib",
   title: none,
   style: "bibliography/apalike.csl"
))
