from database.square import Square


def set_square_type(square:Square):
    if square.side1 == square.side2 and square.side1 == square.side3 and square.side1 == square.side4:
        square.type = "square"

    else:
        square.type = "not a square"


def verify_square(square:Square):
    if not square.side1:
        return False

    elif not square.side2:
        return False

    elif not square.side3:
        return False
    
    elif not square.side4:
        return False

    elif square.side1 == square.side2 == square.side3 != square.side4:
        return False

    elif square.side1 == square.side2 != square.side3 == square.side4:
        return False

    elif square.side1 != square.side2 == square.side3 != square.side4:
        return False

    else:
        return True

