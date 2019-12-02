module Models exposing (Area, AreaParameters, Model, areas, values)


type alias Model =
    { parameters : AreaParameters
    , updatedArea : Area
    }


type alias AreaParameters =
    { workload : Float
    , control : Float
    , reward : Float
    , community : Float
    , fairness : Float
    , values : Float
    }


type alias Area =
    { name : String, getter : AreaParameters -> Float, setter : AreaParameters -> Float -> AreaParameters }


areas : List Area
areas =
    [ { name = "workload", getter = \m -> m.workload, setter = \m v -> { m | workload = v } }
    , { name = "control", getter = \m -> m.control, setter = \m v -> { m | control = v } }
    , { name = "reward", getter = \m -> m.reward, setter = \m v -> { m | reward = v } }
    , { name = "community", getter = \m -> m.community, setter = \m v -> { m | community = v } }
    , { name = "fairness", getter = \m -> m.fairness, setter = \m v -> { m | fairness = v } }
    , values
    ]


values =
    { name = "values", getter = \m -> m.values, setter = \m v -> { m | values = v } }
