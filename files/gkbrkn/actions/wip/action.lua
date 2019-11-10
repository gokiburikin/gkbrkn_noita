local before = gun.shuffle_deck_when_empty;
gun.shuffle_deck_when_empty = false;
order_deck();
gun.shuffle_deck_when_empty = before;
draw_actions( 1, true );