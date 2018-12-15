port module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Html exposing (Html, button, div, text, textarea)
import Html.Events exposing (onClick, onInput)


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type alias Model =
    { content : String, output : String, error : String }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model "" "" "", Cmd.none )



-- UPDATE


type Msg
    = Content String
    | Change
    | Output String
    | Error String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Content newContent ->
            ( { model | content = newContent }, Cmd.none )

        Change ->
            ( model, toJs model.content )

        Output newJson ->
            ( { model | output = newJson, error = "" }, Cmd.none )

        Error error ->
            ( { model | output = "", error = error }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ toElm Output
        , toElmErr Error
        ]



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ textarea [ onInput Content ] []
        , textarea [] [ text model.output ]
        , div [] [ text model.error ]
        , button [ onClick Change ] [ text "change" ]
        ]



-- Port


port toJs : String -> Cmd msg


port toElm : (String -> msg) -> Sub msg


port toElmErr : (String -> msg) -> Sub msg
