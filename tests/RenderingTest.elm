module RenderingTest exposing (test1)

import Expect
import Test exposing (Test, test)


test1 : Test
test1 =
    test "Empty" <| \_ -> Expect.equal () ()
