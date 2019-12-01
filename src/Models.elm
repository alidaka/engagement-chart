module Models exposing (Field, Model, fields)


type alias Model =
    { workload : Float
    , control : Float
    , reward : Float
    , community : Float
    , fairness : Float
    , values : Float
    }


type alias Field =
    { name : String, getter : Model -> Float, setter : Model -> Float -> Model }


fields : List Field
fields =
    [ { name = "workload", getter = \m -> m.workload, setter = \m v -> { m | workload = v } }
    , { name = "control", getter = \m -> m.control, setter = \m v -> { m | control = v } }
    , { name = "reward", getter = \m -> m.reward, setter = \m v -> { m | reward = v } }
    , { name = "community", getter = \m -> m.community, setter = \m v -> { m | community = v } }
    , { name = "fairness", getter = \m -> m.fairness, setter = \m v -> { m | fairness = v } }
    , { name = "values", getter = \m -> m.values, setter = \m v -> { m | values = v } }
    ]
