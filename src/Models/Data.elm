module Models.Data exposing (..)

type PieceType
    = Rook
    | Knight
    | Bishop
    | King
    | Queen
    | Pawn


type Color
    = White
    | Black


initialBoard =
    [ (( 0, 0 )
    , { color = White, pieceType = Rook })
    , (( 0, 1 )
    , { color = White, pieceType = Knight })
    , (( 0, 2 )
    , { color = White, pieceType = Bishop })
    , (( 0, 3 )
    , { color = White, pieceType = Queen })
    , (( 0, 4 )
    , { color = White, pieceType = King })
    , (( 0, 5 )
    , { color = White, pieceType = Bishop })
    , (( 0, 6 )
    , { color = White, pieceType = Knight })
    , (( 0, 7 )
    , { color = White, pieceType = Rook })
    , (( 1, 0 )
    , { color = White, pieceType = Pawn })
    , (( 1, 1 )
    , { color = White, pieceType = Pawn })
    , (( 1, 2 )
    , { color = White, pieceType = Pawn })
    , (( 1, 3 )
    , { color = White, pieceType = Pawn })
    , (( 1, 4 )
    , { color = White, pieceType = Pawn })
    , (( 1, 5 )
    , { color = White, pieceType = Pawn })
    , (( 1, 6 )
    , { color = White, pieceType = Pawn })
    , (( 1, 7 )
    , { color = White, pieceType = Pawn })
    , (( 6, 0 )
    , { color = Black, pieceType = Pawn })
    , (( 6, 1 )
    , { color = Black, pieceType = Pawn })
    , (( 6, 2 )
    , { color = Black, pieceType = Pawn })
    , (( 6, 3 )
    , { color = Black, pieceType = Pawn })
    , (( 6, 4 )
    , { color = Black, pieceType = Pawn })
    , (( 6, 5 )
    , { color = Black, pieceType = Pawn })
    , (( 6, 6 )
    , { color = Black, pieceType = Pawn })
    , (( 6, 7 )
    , { color = Black, pieceType = Pawn })
    , (( 7, 0 )
    , { color = Black, pieceType = Rook })
    , (( 7, 1 )
    , { color = Black, pieceType = Knight })
    , (( 7, 2 )
    , { color = Black, pieceType = Bishop })
    , (( 7, 3 )
    , { color = Black, pieceType = King })
    , (( 7, 4 )
    , { color = Black, pieceType = Queen })
    , (( 7, 5 )
    , { color = Black, pieceType = Bishop })
    , (( 7, 6 )
    , { color = Black, pieceType = Knight })
    , (( 7, 7 )
    , { color = Black, pieceType = Rook })
    ]
