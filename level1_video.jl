# переписать ниже примеры из первого часа из видеолекции: 
# https://youtu.be/4igzy3bGVkQ
# по желанию можно поменять значения и попробовать другие функции


# Getting started
println("I'm excited to learn Julia!")

123
456;

my_answer = 42
typeof(my_answer)

my_pi = 3.14159
typeof(my_pi)

my_name = "Alex"
typeof(my_name)

my_answer = my_name

# Single line comment

#= Multi-line
comments
=#

sum_ = 3+7

diffeence = 10-3

product_ = 20*5

quotient = 100/10

power = 1^2

modulus = 101 % 2


# Strings

s1 = "I am a string"

s2 = """I am also a string"""

"Here we get "error" with this ambiguous quotes"

"""And here are no "errors"!"""

typeof('a')

'Here is a ParseError'

name = "Alex"
num_apples = 7
num_oranges = 5

println("Hello, my name is $name")
println("I have $num_oranges oranges and $num_apples appes ($(num_apples+num_oranges) fruits total).")

string("String literal 1", " ", "String literal 3")
string("It's ", "literally ", 1984)

s3 = "How many cats";
s4 = " are too many cats?";

s3 * s4

"$s3$s4"



# Data structures

myphonebook = Dict("Jenny" => "867-5309", "Ghostbusters"=>"555-2368")

myphonebook["Connor Sarah"] = "1823"

myphonebook

myphonebook["Connor Sarah"]

pop!(myphonebook, "Connor Sarah")

myphonebook

myphonebook[1]


myfavoriteanimals = ("penguins", "cats", "sugargliders")

myfavoriteanimals[1]

myfavoriteanimals[1] = "otters"


myfriends = ["Ted", "Robyn", "Barney", "Lily", "Marshall"]

fibonacci = [1, 1, 2, 3, 5, 8, 13]

mix = [1,2, 3.0, "otter"]

myfriends[4]

myfriends[4] *= " Smith"

push!(fibonacci, 21)

pop!(fibonacci)

fibonacci

favorites = [["koobideh", "chocolate", "eggs"], ["penguins", "cats", "sugargliders"]]

numbers = [[1,2,3], [4,5], [6,7,8,9]]

rand(4,3)

rand(4,3,2)


# Loops

n = 0
while n< 10
    n += 1
    println(n)
end


myfriends = ["Ted", "Robyn", "Barney", "Lily", "Marshall"]


i = 1
while i <= length(myfriends)
    friend = myfriends[i]
    println("Hi, $(friend)!")
    i += 1
end


for n in 1:10
    println(n)
end

for n = 1:10
    println(n)
end

for n ∈ 1:10
    println(n)
end

for friend in myfriends
    println("Hi, $(friend)!")
end

m, n = rand(2:7), rand(2:7)
A = zeros(Int, m, n)

for i in 1:m
    for j in 1:n
        A[i, j] = i+j
    end
end
A

B = zeros(Int, m, n)
for i in 1:m, j in 1:n
    B[i,j] = i+j
end

C = [i + j for i in 1:m, j in 1:n]

[i + j for i in 1:m for j in 1:n]

[[i + j for i in 1:m] for j in 1:n]

for n in 1:10
    A = [i + j for i in 1:m, j in 1:n]
    display(A)
end


# Conditionals

x = 3
y = 90

if x > y
    println("$x > $y")
elseif y > x
    println("$y > $x")
else
    println("$x equals $y")
end

if x > y
    x
else
    y
end

x > y ? x : y

x > y && println("$x is larger than $y")
x < y && println("$x is smaller than $y")



# Functions
function sayhi(name)
    println("Hi $(name)!")
end

function f(x)
    x^2
end

sayhi("Harry Potter")

f(1.4142136)


sayhi2(name) = println("Hi $(name), glad you're here!")

sayhi2("Anakyn")

f2(x) = x^2

f2(1.7321)

sayhi3 = name -> println("Hi $(name), welcome back!")

f3 = x -> x^2

sayhi3("Emmanuel Macron")

f3(8.31)


sayhi(123456)
A = rand(3,3)
f(A)

f(rand(4))


v = [3,5,2]

sort(v)

v

sort!(v)

v



# Broadcasting

A = [i + 3j for j in 0:2, i in 1:3]

f(A)

B = f.(A)

A[2,2]

@assert A[2,2]^2 == B[2,2]

f.(v)




# Packages

using Pkg

Pkg.add("Example")

using Example

hello("some random string")

Pkg.add("Colors")

using Colors

palette = distinguishable_colors(20)

rand(palette, 50,50)





# Plots 

Pkg.add("Plots")

using Plots

x = -3:0.1:3
f(x) = x * x

y = f.(x)

gr()

plot(x, y, label="line label")
scatter!(x,y, label = "points")


plotlyjs()

Pkg.add("PlotlyJS")

plotlyjs()

plot(x, y, label="line label")
scatter!(x,y, label = "points")


gr()


x = 1:1e-1:40
y = sin.(x) ./ exp.(0.1x) + 0.2*rand(length(x)) .- 0.5

plot(y)

xflip!()

xlabel!("Why it goes in reverse?")
ylabel!("And what does that mean?")
title!("well ok")


p1 = scatter(randn(length(x)), randn(length(x)))
p2 = plot(x, sqrt.(x))
p3 = plot(x, log.(x))
p4 = plot(x, x.*log.(x))
plot(p1, p2, p3, p4, layout=(2,2), legend=false)



# Multiple dispatch
methods(+)

@which 3 + 3

@which 3.0 + 3.0

@which 3.0 + 3


import Base: +

"hello " + "world!"

@which "hello " + "world!"

+(a::String, b::String) = string(a, b)

@which "hello " + "world!"

"hello " + "world!"


foo(x, y) = println("Duck-typed")
foo(x::Int, y::Float64) = println("Int and Float64")
foo(x::Float64, y::Float64) = println("Both floats")
foo(x::Int, y::Int) = println("Both ints")

foo(1,1)
foo(1.,1)
foo(1,1.)
foo(1.,1.)

foo("A", 'B')



# Basic linear algebra

A = rand(1:4, 3,3)

B = A
C = copy(A)

[B C]

A[1] = 17

[B C]

x = ones(3)

b = A*x

Asym = A + A'

Apd = A'A

A\b

Atall = A[:, 1:2]
Atall\b

A = randn(3,3)

[A[:, 1] A[:, 1]]\b

Ashort = A[1:2, :]
Ashort\b[1:2]