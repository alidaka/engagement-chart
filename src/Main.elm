module Main exposing (Msg(..), areas, calculateValues, chart, init, kernel, main, series, transformTypes, update, view)

import Browser
import Css exposing (column, displayFlex, flexDirection, margin, px, row)
import Html.Styled exposing (Html, button, div, fromUnstyled, text, toUnstyled)
import Html.Styled.Attributes exposing (css)
import Html.Styled.Events exposing (onClick)
import LineChart
import Models exposing (Area, AreaParameters, Model)


main =
    Browser.sandbox { init = init, update = update, view = view >> toUnstyled }


type Msg
    = Increment Area
    | Decrement Area


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
        Increment area ->
            { parameters = area.setter parameters (area.getter parameters + 1)
            , updatedArea = area
            }

        Decrement area ->
            { parameters = area.setter parameters (area.getter parameters - 1)
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
                [ button [ onClick <| Decrement area ] [ text "-" ]
                , div [] [ text <| fieldName ]
                , button [ onClick <| Increment area ] [ text "+" ]
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
