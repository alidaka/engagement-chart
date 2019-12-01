module Main exposing (Msg(..), chart, fields, init, main, update, view)

import Browser
import Css exposing (column, displayFlex, flexDirection, margin, px, row)
import Html.Styled exposing (Html, button, div, text, toUnstyled)
import Html.Styled.Attributes exposing (css)
import Html.Styled.Events exposing (onClick)
import LineChart
import Models exposing (Field, Model)


main =
    Browser.sandbox { init = init, update = update, view = view >> toUnstyled }


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
    div [ css [ displayFlex, flexDirection column ] ]
        [ fields model, chart model ]


fields model =
    let
        viewForField field =
            let
                fieldName =
                    field.name ++ ": " ++ String.fromFloat (field.getter model)
            in
            div [ css [ margin (px 32) ] ]
                [ button [ onClick <| Decrement field ] [ text "-" ]
                , div [] [ text <| fieldName ]
                , button [ onClick <| Increment field ] [ text "+" ]
                ]
    in
    div [ css [ displayFlex, flexDirection row ] ] (List.map viewForField Models.fields)


chart model =
    div [] []
