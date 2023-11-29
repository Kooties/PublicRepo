fizz = 3
buzz = 5

while True:
    try:
        maxValue = int(input("How many numbers do you want?"))
    except ValueError:
        print("Please enter a whole number")
        continue
    if maxValue < 0:
        print("Sorry, negative numbers not supported")
        continue
    else:
        break

while type(maxValue) == int:
    i=1
    while i <= maxValue:
        if ((i % buzz == 0) and (i % fizz == 0)):
            print ("fizzbuzz")
        elif i % fizz == 0:
            print("fizz")
        elif i % buzz == 0:
            print("buzz")
        else:
            print(i)
        i += 1
    if i > maxValue:
        break
else:
    print("You did not input a number")