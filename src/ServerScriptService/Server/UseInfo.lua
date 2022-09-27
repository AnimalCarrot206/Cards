export type CardUseBaseInfo = {
    cardOwner: Player,
    cardOwnerDeck: any,
}
export type SelfUseInfo = CardUseBaseInfo
export type OnPlayerUseInfo = CardUseBaseInfo & {
    defender: Player,
    defenderDeck: any,
}
export type CouplePlayersUseInfo = CardUseBaseInfo & {
    players: {Player},
    decks: {any},
}
return nil