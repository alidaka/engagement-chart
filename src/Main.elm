module Main exposing (Msg(..), areas, calculateValues, chart, init, kernel, main, series, transformTypes, update, view)

import Browser
import Css exposing (column, displayFlex, flexDirection, margin, px, row)
import Debug
import Html.Styled exposing (Html, button, div, fromUnstyled, input, text, toUnstyled)
import Html.Styled.Attributes exposing (css, type_)
import Html.Styled.Events exposing (onInput)
import LineChart
import Models exposing (Area, AreaParameters, Model)


main =
    Browser.sandbox { init = init, update = update, view = view >> toUnstyled }


type Msg
    = Set Area String


init : Model
init =
    { parameters =
        { workload = 50
        , control = 50
        , reward = 50
        , community = 50
        , fairness = 50
        , values = 50
        }
    , updatedArea = Models.values
    }


update : Msg -> Model -> Model
update msg { parameters } =
    case msg of
        Set area value ->
            let
                val =
                    case String.toFloat (Debug.log value value) of
                        Just f ->
                            f

                        Nothing ->
                            area.getter parameters
            in
            { parameters = area.setter parameters val
            , updatedArea = area
            }


view : Model -> Html Msg
view model =
    div [ css [ displayFlex, flexDirection column ] ]
        [ areas model.parameters, chart model ]


areas model =
    let
        viewForField area =
            let
                fieldName =
                    area.name ++ ": " ++ String.fromFloat (area.getter model)
            in
            div [ css [ margin (px 32) ] ]
                [ div [] [ text fieldName ]

                -- note: worrying comment on #onInput for type=range:
                -- https://github.com/rtfeldman/elm-css/blob/master/src/Html/Styled/Events.elm
                -- TODO: also move the String->Float logic out of update, into here
                , input [ type_ "range", onInput <| Set area ] [ text "+" ]
                ]
    in
    div [ css [ displayFlex, flexDirection row ] ] (List.map viewForField Models.areas)



--- TODO: see LineChart.viewCustom, pick correct interpolation mode


chart model =
    div [] [ fromUnstyled <| LineChart.view1 Tuple.first Tuple.second (series model) ]


series : Model -> List ( Float, Float )
series model =
    List.repeat 100 model.parameters
        |> List.indexedMap (\x -> calculateValues model.updatedArea x)
        |> List.map transformTypes


calculateValues : Area -> Int -> AreaParameters -> ( Float, AreaParameters )
calculateValues area index parameters =
    let
        idx =
            toFloat index
    in
    Tuple.pair idx (area.setter parameters idx)


transformTypes : ( Float, AreaParameters ) -> ( Float, Float )
transformTypes ( index, parameters ) =
    let
        value =
            List.map (\area -> area.getter parameters) Models.areas
                |> List.map kernel
                |> List.product
    in
    Tuple.pair index value


kernel value =
    (/) value 500
        |> max 0.01
        |> (^) 2
