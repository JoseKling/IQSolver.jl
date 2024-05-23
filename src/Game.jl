# These are the pieces available in the game.
# Their names refer to the color. It always start with 'l', 'm', or 'd', for
# light, middle, and dark.
# To maintain the standard and not have any conflicts with any color names I
# appended an 'm' even for colors that appear only once, like 'm_orange'.
l_blue = Piece([0 0; 0 1; 1 0], colorant"lightskyblue1")
d_blue = Piece([0 0; 0 1; 0 2; 1 1], colorant"teal")
d_red = Piece([0 0; 1 0; 1 1; 2 1], colorant"red4")
d_green = Piece([0 0; 0 1; 0 2; 1 0], colorant"darkblue")
m_yellow = Piece([0 0; 0 1; 0 2; 0 3; 1 1], colorant"yellow")
m_blue = Piece([0 0; 0 1; 0 2; 1 0; 2 0], colorant"dodgerblue")
m_red = Piece([0 0; 0 1; 0 2; 0 3; 1 0], colorant"red")
m_green = Piece([0 0; 0 1; 0 2; 1 0; 1 2], colorant"olivedrab2")
l_green = Piece([0 0; 0 1; 0 2; 1 0; 1 1], colorant"darkseagreen1")
m_purple = Piece([0 0; 0 1; 1 1; 1 2; 2 2], colorant"purple4")
m_orange = Piece([0 0; 0 1; 1 1; 1 2; 2 1], colorant"orange")
m_pink = Piece([0 0; 0 1; 1 1; 1 2; 1 3], colorant"lightpink1")

game_pieces = [l_blue,
    d_blue,
    d_red,
    d_green,
    m_yellow,
    m_blue,
    m_red,
    m_green,
    l_green,
    m_purple,
    m_orange,
    m_pink]

