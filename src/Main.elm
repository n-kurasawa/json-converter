module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Html exposing (Html, button, div, text, textarea)
import Html.Events exposing (onClick, onInput)
import Json.Decode as D
import Json.Encode as E


main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model =
    { content : String, output : String }


type alias Cause =
    { name : String
    , percent : Float
    , per100k : Float
    }


init : Model
init =
    { content = "", output = "" }



-- UPDATE


type Msg
    = Content String
    | Change


update : Msg -> Model -> Model
update msg model =
    case msg of
        Content newContent ->
            { model | content = newContent }

        Change ->
            { model | output = changeJson model.content }


changeJson : String -> String
changeJson jsonString =
    case D.decodeString decoder jsonString of
        Ok json ->
            E.encode 4 (encode json)

        Err message ->
            "err"



-- ENCODE


encode : Cause -> E.Value
encode cause =
    E.object
        [ ( "name", E.string cause.name )
        , ( "percent", E.float cause.percent )
        , ( "per100k", E.float cause.per100k )
        ]



-- DECODER


decoder : D.Decoder Cause
decoder =
    D.map3 Cause
        (D.field "name" D.string)
        (D.field "percent" D.float)
        (D.field "per100k" D.float)



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ textarea [ onInput Content ] []
        , textarea [] [ text model.output ]
        , button [ onClick Change ] [ text "change" ]
        ]
