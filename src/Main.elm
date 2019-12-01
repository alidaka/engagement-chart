module Main exposing (Msg(..), init, main, update, view, viewForField)

import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import LineChart
import Models exposing (Field, Model)


main =
    Browser.sandbox { init = init, update = update, view = view }


type Msg
    = Increment Field
    | Decrement Field


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
            Models.fields
        )


viewForField model field =
    div []
        [ button [ onClick <| Decrement field ] [ text "-" ]
        , div [] [ text <| field.name ++ ": " ++ String.fromInt (field.getter model) ]
        , button [ onClick <| Increment field ] [ text "+" ]
        ]
