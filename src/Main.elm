module Main exposing (Msg(..), main, update, view)

import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import LineChart


main =
    Browser.sandbox { init = init, update = update, view = view }


type Msg
    = Increment Field
    | Decrement Field


type alias Model =
    { workload : Int
    , control : Int
    , reward : Int
    , community : Int
    , fairness : Int
    , values : Int
    }


type alias Field =
    { name : String, getter : Model -> Int, setter : Model -> Int -> Model }


fields : List Field
fields =
    [ { name = "workload", getter = \m -> m.workload, setter = \m v -> { m | workload = v } }
    , { name = "control", getter = \m -> m.control, setter = \m v -> { m | control = v } }
    , { name = "reward", getter = \m -> m.reward, setter = \m v -> { m | reward = v } }
    , { name = "community", getter = \m -> m.community, setter = \m v -> { m | community = v } }
    , { name = "fairness", getter = \m -> m.fairness, setter = \m v -> { m | fairness = v } }
    , { name = "values", getter = \m -> m.values, setter = \m v -> { m | values = v } }
    ]


init : Model
init =
    { workload = 0
    , control = 0
    , reward = 0
    , community = 0
    , fairness = 0
    , values = 0
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment field ->
            field.setter model
                (field.getter model + 1)

        Decrement field ->
            field.setter model
                (field.getter model - 1)


view : Model -> Html Msg
view model =
    div []
        (List.map
            (viewForField model)
            fields
        )


viewForField model field =
    div []
        [ button [ onClick <| Decrement field ] [ text "-" ]
        , div [] [ text <| field.name ++ ": " ++ String.fromInt (field.getter model) ]
        , button [ onClick <| Increment field ] [ text "+" ]
        ]
