///|
fn group(xs : Array[Doc], max_column? : Int = 80) -> Array[ArrayView[Doc]] {
  let res = []
  let mut width = 0
  let mut start = 0
  for i in 0..<xs.length() {
    if width > max_column {
      res.push(xs[start:i])
      start = i
      width = 0
    }
    width += xs[i].width() + 2
  }
  if start < xs.length() {
    res.push(xs[start:xs.length()])
  }
  res
}

///|
fn pretty_print(json : Json, max_column? : Int = 80) -> Doc {
  match json {
    Array(xs) => {
      let xs = xs.map(fn(x) { pretty_print(x) })
      let mut doc = Doc::empty()
      for x in group(xs) {
        let group = x
          .fold(init=Doc::empty(), Doc::vertical_concat)
          .join(separator=", ")
          |> Doc::from_line
        doc = doc.vertical_concat(group)
      }
      let mut i = 0
      let height = doc.height()
      let doc = doc
        .inner()
        .iter()
        .map(fn(line) {
          i += 1
          if i == height {
            line
          } else {
            line.snoc(",")
          }
        })
        |> Doc::from_iter
      doc.envelop(left="[", right="]")
    }
    String(val) => Doc::from_string(val.escape())
    Number(val, ..) => Doc::from_string(val.to_string())
    False => Doc::from_string("false")
    True => Doc::from_string("true")
    Null => Doc::from_string("null")
    Object(obj) => {
      fn kv(k, v) {
        let k = Line::from_string(k).cons("\"").snoc("\"") |> Doc::from_line
        let v = pretty_print(v)
        k.joinline(v, separator=Some(" : "))
      }

      let mut doc = Doc::empty()
      let mut i = 0
      for k, v in obj {
        if i == obj.size() - 1 {
          doc = doc.vertical_concat(kv(k, v))
        } else {
          doc = doc.vertical_concat(kv(k, v).joinline(Doc::from_string(",")))
        }
        i += 1
      }
      Doc::from_string("{")
      .vertical_concat(doc.indent(2))
      .vertical_concat(Doc::from_string("}"))
    }
  }
}

///|
test "JSON/array" {
  let arr_items = Array::makei(100, fn(x) { x.to_json() })
  let arr : Json = arr_items.to_json()
  inspect(
    pretty_print(arr),
    content=(
      #|[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22,
      #|23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43,
      #|44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64,
      #|65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85,
      #|86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99]
      #|
    ),
  )
}

///|
test "JSOM/pretty_print" {
  let json : Json = { "x": 1, "y": 2 }
  inspect(
    pretty_print(json),
    content=(
      #|{
      #|  "x" : 1,
      #|  "y" : 2
      #|}
      #|
    ),
  )
  let expected : Json = {
    "glossary": {
      "title": "example glossary",
      "GlossDiv": {
        "title": "S",
        "GlossList": {
          "GlossEntry": {
            "ID": "SGML",
            "SortAs": "SGML",
            "GlossTerm": "Standard Generalized Markup Language",
            "Acronym": "SGML",
            "Abbrev": "ISO 8879:1986",
            "GlossDef": {
              "para": "A meta-markup language, used to create markup languages such as DocBook.",
              "GlossSeeAlso": ["GML", "XML"],
            },
            "GlossSee": "markup",
          },
        },
      },
    },
  }
  inspect(
    pretty_print(expected),
    content=(
      #|{
      #|  "glossary" : {
      #|    "title" : "example glossary",
      #|    "GlossDiv" : {
      #|      "title" : "S",
      #|      "GlossList" : {
      #|        "GlossEntry" : {
      #|          "ID" : "SGML",
      #|          "SortAs" : "SGML",
      #|          "GlossTerm" : "Standard Generalized Markup Language",
      #|          "Acronym" : "SGML",
      #|          "Abbrev" : "ISO 8879:1986",
      #|          "GlossDef" : {
      #|            "para" : "A meta-markup language, used to create markup languages such as DocBook.",
      #|            "GlossSeeAlso" : ["GML", "XML"]
      #|          },
      #|          "GlossSee" : "markup"
      #|        }
      #|      }
      #|    }
      #|  }
      #|}
      #|
    ),
  )
  let str_json = pretty_print(expected).to_string()
  let actual = @json.parse(str_json)
  assert_eq(expected, actual)
}

///|
test "stack overflow test" {
  let len = 1 << 16
  let arr = Array::makei(len, fn(i) { i.to_json() }).to_json()
  let str = pretty_print(arr).to_string()
  inspect(str.length(), content="447643")
}
