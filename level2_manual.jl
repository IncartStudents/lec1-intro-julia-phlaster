# Выболнить большую часть заданий ниже - привести примеры кода под каждым комментарием


#===========================================================================================
1. Переменные и константы, области видимости, cистема типов:
приведение к типам,
конкретные и абстрактные типы,
множественная диспетчеризация,
=#

# Что происходит с глобальной константой PI, о чем предупреждает интерпретатор?
const PI = 3.14159
PI = 3.14

# Неудачная попытка переопределения константы
# ERROR: invalid assignment to constant Main.PI. This redefinition may be permitted using the `const` keyword.


# Что происходит с типами глобальных переменных ниже, какого типа `c` и почему?
a = 1
b = 2.0
c = a + b
# Промоушн двух типов с общим абстранктым предком к ближайшему общему конкретному типу
# julia> @which a+b
# +(x::Number, y::Number)
#      @ Base promotion.jl:433


# Что теперь произошло с переменной а? Как происходит биндинг имен в Julia?
a = "foo"
# переменная переопределилась, тип динмически изменён 


# Что происходит с глобальной переменной g и почему? Чем ограничен биндинг имен в Julia?
g::Int = 1
g = "hi"
# Мы статически проаннотировали переменную типом, который теперь уже не может измениться. Попытка присвоить знчение другого типа поднимают ошибку 
# ERROR: MethodError: Cannot `convert` an object of type String to an object of type Int64


function greet()
    g = "hello"
    println(g)
end
greet()
# ошибки нет, т.к. g внутри функции имеет ограниченное поле видимости, определяется внутри тела функции и не связано с глобальным именем g

# Чем отличаются присвоение значений новому имени - и мутация значений?
v = [1,2,3]
z = v # копирует ссылку на объект, а не сам объект.
v[1] = 3 # мутирует массив по ссылке. `z` видит изменение, так как указывает на тот же массив.
v = "hello" # переназначает имя `v` на новый объект (строку). `z` остается ссылкой на исходный массив
z
# julia> z
# 3-element Vector{Int64}:
#  3
#  2
#  3


# Написать тип, параметризованный другим типом

struct Wrapper{T}
    value::T
end
Wrapper{Int64}(1)
Wrapper{String}("text")

#=
Написать функцию для двух аругментов, не указывая их тип,
и вторую функцию от двух аргментов с конкретными типами,
дать пример запуска
=#

f_generic(a, b) = a + b
f_specific(a::Int, b::Int) = a * b


# julia> @which f_generic(2, 3.0)
# f_generic(a, b)
#      @ Main ~/Documents/Git/Hub/lec1-intro-julia-phlaster/level2_manual.jl:75

# julia> @which f_specific(2, 3)
# f_specific(a::Int64, b::Int64)
#      @ Main ~/Documents/Git/Hub/lec1-intro-julia-phlaster/level2_manual.jl:76

# julia> @which f_specific(2, 3.0)
# ERROR: Calling invoke(f, t, args...) would throw:
# MethodError: no method matching invoke f_specific(::Int64, ::Float64)
# The function `f_specific` exists, but no method is defined for this combination of argument types.



#=
Абстрактный тип - ключевое слово? abstract type
Примитивный тип - ключевое слово? primitive type
Композитный тип - ключевое слово? struct (или mutable struct)
=#

#=
Написать один абстрактный тип и два его подтипа (1 и 2)
Написать функцию над абстрактным типом, и функцию над её подтипом-1
Выполнить функции над объектами подтипов 1 и 2 и объяснить результат
(функция выводит произвольный текст в консоль)
=#
abstract type Shape end
struct Circle <: Shape end
struct Square <: Shape end

draw(s::Shape) = println("Drawing a generic shape")
draw(c::Circle) = println("Drawing a circle")

# julia> draw(Circle())
# Drawing a circle

# julia> draw(Square())
# Drawing a generic shape

#===========================================================================================
2. Функции:
лямбды и обычные функции,
переменное количество аргументов,
именованные аргументы со значениями по умолчанию,
кортежи
=#

# Пример обычной функции
function add(x, y)
    x + y
end
# julia> add(3, 2)
# 5

# Пример лямбда-функции (аннонимной функции)
lambda_add = (x, y) -> x + y
# julia> lambda_add(5,10)
# 15

# Пример функции с переменным количеством аргументов
function sum_all(args...)
    sum(args)
end
# julia> sum_all(1,2,3)
# 6
# julia> sum_all(1,2,3,5,6,7,8)
# 32

# Пример функции с именованными аргументами
function greet(name; greeting="Hello")
    println("$greeting, $name")
end
# julia> greet("Peter")
# Hello, Peter
# julia> greet("Peter"; greeting="Good day")
# Good day, Peter


# Функции с переменным кол-вом именованных аргументов
function print_kwargs(; kwargs...)
    for (k, v) in kwargs
        println("$k = $v")
    end
end
# julia> print_kwargs(a='a', b='c', c='x')
# a = a
# b = c
# c = x


#=
Передать кортеж в функцию, которая принимает на вход несколько аргументов.
Присвоить кортеж результату функции, которая возвращает несколько аргументов.
Использовать splatting - деструктуризацию кортежа в набор аргументов.
=#
function multi_args(a, b, c)
    return a[1] + b.stop + round(Int, c)
end
t = ([3,4,5], 5:10, 3.5)
# julia> multi_args(t...)
# 17


#===========================================================================================
3. loop fusion, broadcast, filter, map, reduce, list comprehension
=#

#=
Перемножить все элементы массива
- через loop fusion и
- с помощью reduce
=#
arr = [1, 2, 3, 4]

# Loop fusion
prod_loop = 1
for x in arr
    prod_loop *= x
end
# julia> prod_loop
# 24

# reduce
prod_reduce = reduce(*, arr)
# julia> prod_reduce
# 24


#=
Написать функцию от одного аргумента и запустить ее по всем элементам массива
с помощью точки (broadcast)
c помощью map
c помощью list comprehension
указать, чем это лучше явного цикла?
=#
f(x) = x^2
arr = [1, 2, 3]

res_broadcast = f.(arr)
res_map = map(f, arr)
res_comp = [f(x) for x in arr]
# Преимущество: код декларативнее, компилятор лучше оптимизирует (векторизация, fusion),



# Перемножить вектор-строку [1 2 3] на вектор-столбец [10,20,30] и объяснить результат
row = [1 2 3]
col = [10, 20, 30]
res_matrix = row * col
# julia> res_matrix
# 1-element Vector{Int64}:
#  140
# В Julia векторы по умолчанию column vectors. Здесб row это матрица, получаем при умножении скалярное произведение




# В одну строку выбрать из массива [1, -2, 2, 3, 4, -5, 0] только четные и положительные числа
[x for x in [1, -2, 2, 3, 4, -5, 0] if x > 0 && iseven(x)]


# Объяснить следующий код обработки массива names - что за number мы в итоге определили?
using Random
# Вызов модуля (стандартная библиотека)
Random.seed!(123)
# Явное указание состояния глобального состояния рандомайзера для детерменированного воспроизводимого результата
names = [rand('A':'Z') * '_' * rand('0':'9') * rand([".csv", ".bin"]) for _ in 1:100]
# 100 случайных имён файлов по заданному шаблону и с одним из двух расширений
# ---
same_names = unique(map(y -> split(y, ".")[1], filter(x -> startswith(x, "A"), names)))
# Фильтруются имена, начинающиеся на "A", убирается расширение файла, убираются дубликаты
numbers = parse.(Int, map(x -> split(x, "_")[end], same_names))
# Извлекается цифра после подчеркивания
numbers_sorted = sort(numbers)
# Цифры сортируются
number = findfirst(n -> !(n in numbers_sorted), 0:9)
# number - первая цифра от 0 до 9, которая отсутствует в полученном списке, либо nothing, если бы в numbers_sorted присутствовали все


# Упростить этот код обработки:
number = 2
# Если все аргументы функций, как и сид генератора, захардкожены, то результ вычислений известен наперёд.
# Идеальный компилятор в таком случае заменил бы все вызовы на константу.
# P.S. Значение валидно с точностью до версии генератора случайных чисел.

#===========================================================================================
4. Свой тип данных на общих интерфейсах
=#

#=
написать свой тип ленивого массива, каждый элемент которого
вычисляется при взятии индекса (getindex) по формуле (index - 1)^2
=#
struct LazySquares <: AbstractArray{Int, 1}
    len::Int
end
LazySquares(len::Integer) = LazySquares(Int(len))
Base.size(A::LazySquares) = (A.len,)
function Base.getindex(A::LazySquares, i::Int)
    @boundscheck 1 <= i <= A.len || throw(BoundsError(A, i))
    return (i - 1)^2
end
# julia> LazySquares(5)
# 5-element LazySquares:
#   0
#   1
#   4
#   9
#  16



#=
Написать два типа объектов команд, унаследованных от AbstractCommand,
которые применяются к массиву:
`SortCmd()` - сортирует исходный массив
`ChangeAtCmd(i, val)` - меняет элемент на позиции i на значение val
Каждая команда имеет конструктор и реализацию метода apply!
=#
abstract type AbstractCommand end
apply!(cmd::AbstractCommand, target::Vector) = error("Not implemented for type $(typeof(cmd))")


struct SortCmd <: AbstractCommand end

struct ChangeAtCmd{T} <: AbstractCommand
    i::Int
    val::T
end

function apply!(cmd::SortCmd, target::Vector)
    sort!(target)
    return nothing
end

function apply!(cmd::ChangeAtCmd, target::Vector)
    checkbounds(target, cmd.i)
    target[cmd.i] = cmd.val
    return nothing
end

data = [5, 2, 9, 1]
queue = [SortCmd(), ChangeAtCmd(1, 100)]
for cmd in queue
    apply!(cmd, data)
end
# julia> data
# 4-element Vector{Int64}:
#  100
#    2
#    5
#    9

# Аналогичные команды, но без наследования и в виде замыканий (лямбда-функций)
sort_cmd() = target -> sort!(target)

change_at_cmd(i::Int, val) = target -> (target[i] = val)
data = [5, 2, 9, 1]
queue = [sort_cmd(), change_at_cmd(1, 100)]

for cmd in queue
    cmd(data)
end
julia> data
# 4-element Vector{Int64}:
#  100
#    2
#    5
#    9

#===========================================================================================
5. Тесты: как проверять функции?
=#

# Написать тест для функции
using Test

function safe_divide(a::Number, b::Number)
    iszero(b) && throw(DivideError())
    return a / b
end

@testset "Safe Divide Logic" begin
    @test safe_divide(10, 2) == 5.0
    @test_throws DivideError safe_divide(10, 0)
    @test safe_divide(0, 5) == 0.0
    @test safe_divide(10.0, 2) == 5.0
end

#===========================================================================================
6. Дебаг: как отладить функцию по шагам?
=#
using Pkg
Pkg.add("Debugger")
using Debugger

#=
Отладить функцию по шагам с помощью макроса @enter и точек останова
=#
function buggy_func()
    E = []
    for T in [Int, Float64, String, Bool]
        z = zero(T)
        @bp
        push!(E, z)
    end
    return E
end

# julia> Debugger.@enter buggy_func()
# In buggy_func() at /home/alex/Documents/Git/Hub/lec1-intro-julia-phlaster/level2_manual.jl:380
#  380  function buggy_func()
# >381      E = []
#  382      for T in [Int, Float64, String, Bool]
#  383          z = zero(T)
# ●384          @bp
#  385          push!(E, z)

# About to run: vect()
# 1|debug> c
# Hit breakpoint:
# In buggy_func() at /home/alex/Documents/Git/Hub/lec1-intro-julia-phlaster/level2_manual.jl:380
#  381      E = []
#  382      for T in [Int, Float64, String, Bool]
#  383          z = zero(T)
# ●384          @bp
# >385          push!(E, z)
#  386      end
#  387      return E
#  388  end

# About to run: push!(Any[], 0)
# 1|debug> c
# Hit breakpoint:
# In buggy_func() at /home/alex/Documents/Git/Hub/lec1-intro-julia-phlaster/level2_manual.jl:380
#  381      E = []
#  382      for T in [Int, Float64, String, Bool]
#  383          z = zero(T)
# ●384          @bp
# >385          push!(E, z)
#  386      end
#  387      return E
#  388  end

# About to run: push!(Any[0], 0.0)
# 1|debug> n
# In buggy_func() at /home/alex/Documents/Git/Hub/lec1-intro-julia-phlaster/level2_manual.jl:380
#  382      for T in [Int, Float64, String, Bool]
#  383          z = zero(T)
# ●384          @bp
#  385          push!(E, z)
# >386      end
#  387      return E
#  388  end

# About to run: iterate(DataType[Int64, Float64, String, Bool], 3)
# 1|debug> n
# In buggy_func() at /home/alex/Documents/Git/Hub/lec1-intro-julia-phlaster/level2_manual.jl:380
#  380  function buggy_func()
#  381      E = []
# >382      for T in [Int, Float64, String, Bool]
#  383          z = zero(T)
# ●384          @bp
#  385          push!(E, z)
#  386      end

# About to run: getfield((String, 4), 1)
# 1|debug> n
# In buggy_func() at /home/alex/Documents/Git/Hub/lec1-intro-julia-phlaster/level2_manual.jl:380
#  380  function buggy_func()
#  381      E = []
#  382      for T in [Int, Float64, String, Bool]
# >383          z = zero(T)
# ●384          @bp
#  385          push!(E, z)
#  386      end
#  387      return E
#  388  end

# About to run: zero(String)
# 1|debug> n
# ERROR: MethodError: no method matching zero(::Type{String})
# The function `zero` exists, but no method is defined for this combination of argument types.

# Closest candidates are:
#   zero(::Type{Union{}}, Any...)
#    @ Base number.jl:315
#   zero(::Type{Dates.DateTime})
#    @ Dates ~/.julia/juliaup/julia-1.12.5+0.x64.linux.gnu/share/julia/stdlib/v1.12/Dates/src/types.jl:458
#   zero(::Type{Dates.Date})
#    @ Dates ~/.julia/juliaup/julia-1.12.5+0.x64.linux.gnu/share/julia/stdlib/v1.12/Dates/src/types.jl:459
#   ...

# Stacktrace:
#  [1] buggy_func()
#    @ Main ~/Documents/Git/Hub/lec1-intro-julia-phlaster/level2_manual.jl:383








#===========================================================================================
7. Профилировщик: как оценить производительность функции?
=#

using Pkg
Pkg.add("ProfileView")
using ProfileView
#=
Оценить производительность функции с помощью макроса @profview,
и добавить в этот репозиторий файл со скриншотом flamechart'а
=#

function generate_data(len)
    vec1 = Any[]
    for k = 1:len
        r = randn(1,1)
        append!(vec1, r)
    end
    vec2 = sort(vec1)
    vec3 = vec2 .^ 3 .- (sum(vec2) / len)
    return vec3
end

@time generate_data(1_000_000);
# 0.605761 seconds (7.00 M allocations: 203.778 MiB, 7.42% gc time)
ProfileView.@profview generate_data(10^6)


# Переписать функцию выше так, чтобы она выполнялась быстрее:
function generate_data_optimized(len)
    vec = randn(len)
    sort!(vec)
    E = (sum(vec) / len)
    @. vec ^ 3 - E
end

@time generate_data_optimized(1_000_000);
# 0.012209 seconds (15 allocations: 19.092 MiB)
ProfileView.@profview generate_data_optimized(10^6)

#===========================================================================================
8. Отличия от матлаба: приращение массива и предварительная аллокация?
=#

#=
Написать функцию определения первой разности, которая принимает и возвращает массив
и для каждой точки входного (x) и выходного (y) выходного массива вычисляет:
y[i] = x[i] - x[i-1]
=#
function diff_alloc(x::Vector{T}) where T<:Number
    n = length(x)
    n < 2 && (return T[])
    [x[i+1] - x[i] for i in 1:(n - 1)]
end


#=
Аналогичная функция, которая отличается тем, что внутри себя не аллоцирует новый массив y,
а принимает его первым аргументом, сам массив аллоцируется до вызова функции
=#
function diff_nalloc!(y::Vector{T}, x::Vector{T}) where T<:Number
    n = length(x)
    length(y) == n-1 || throw(DimensionMismatch())
    @inbounds for i in 1:(n-1)
        y[i] = x[i+1] - x[i]
    end
end


#=
Написать код, который добавляет элементы в конец массива, в начало массива,
в середину массива
=#
arr = [1, 2, 3]

push!(arr, 4)

pushfirst!(arr, 0)

insert!(arr, 3, 10)



#===========================================================================================
9. Модули и функции: как оборачивать функции внутрь модуля, как их экспортировать
и пользоваться вне модуля?
=#


#=
Написать модуль с двумя функциями,
экспортировать одну из них,
воспользоваться обеими функциями вне модуля
=#
module Foo
    export f_exported
    public f_public
    
    f_exported(x) = x^2
    f_public(x) = x^3
end

using .Foo

f_exported(2)
Foo.f_public(2)

#===========================================================================================
10. Зависимости, окружение и пакеты
=#

# Что такое environment, как задать его, как его поменять во время работы?
#=
Окружение в Julia определяется файлами Project.toml и Manifest.toml.
Project.toml хранит список прямых зависимостей и версию проекта.
Manifest.toml хранит точные версии всех зависимостей для воспроизводимости.

Активация окружения выполняется через пакетный менеджер:
using Pkg
Pkg.activate("путь/к/проекту")

Или при запуске Julia через флаг --project (см. раздел 12).
Смена окружения во время работы возможна повторным вызовом Pkg.activate().
=#

# Что такое пакет (package), как добавить новый пакет?
#=
Пакет — это модуль Julia с определенной структурой файлов (src, test, Project.toml),
доступный для установки через реестр (например, General) или по URL на репозиторий.

Добавление пакета в активное окружение:
using Pkg

Pkg.add("Example") # Add a package from registry
Pkg.add("Example", target=:weakdeps) # Add a package as a weak dependency
Pkg.add("Example", target=:extras) # Add a package to the `[extras]` list
Pkg.add("Example"; preserve=Pkg.PRESERVE_ALL) # Add the `Example` package and strictly preserve existing dependencies
Pkg.add(name="Example", version="0.3") # Specify version; latest release in the 0.3 series
Pkg.add(name="Example", version="0.3.1") # Specify version; exact release
Pkg.add(url="https://github.com/JuliaLang/Example.jl", rev="master") # From url to remote gitrepo
Pkg.add(url="/remote/mycompany/juliapackages/OurPackage") # From path to local gitrepo
Pkg.add(url="https://github.com/Company/MonoRepo", subdir="juliapkgs/Package.jl") # With subdir

Или в режиме REPL: ] add PackageName
=#

# Как начать разрабатывать чужой пакет?
#=
Для внесения изменений в существующий пакет используйте режим разработки.
Это создает симлинк на локальную копию пакета вместо загрузки компилированного кода.

Pkg.develop("PackageName") # Для пакета из реестра
Pkg.develop(url="https://github.com/user/Repo.git") # Для репозитория

Или в режиме REPL: ] dev PackageName

После этого изменения в локальной копии пакета применяются немедленно после перезагрузки модуля.
=#

#=
Как создать свой пакет?
(необязательно, эксперименты с PkgTemplates проводим вне этого репозитория)

using PkgTemplates
t = Template()
t("MyPackage")

Это создаст директорию MyPackage с корректной структурой, CI/CD настройками и тестами.
=#


#===========================================================================================
11. Сохранение переменных в файл и чтение из файла.
Подключить пакеты JLD2, CSV.
=#
using Pkg
Pkg.add(["JLD2", "CSV"])
using JLD2, CSV

# Сохранить и загрузить произвольные обхекты в JLD2, сравнить их
begin
    data_orig = Dict("a" => 1, "b" => [1.0, 2.0], "c" => randn, "d" => Main)
    
    filename = tempname(suffix=".jld2")

    save(filename, data_orig)
    
    data_loaded = load(filename)
    
    @assert data_orig == data_loaded
end



Pkg.add("DataFrames")
using DataFrames

# Сохранить и загрузить табличные объекты (массивы) в CSV, сравнить их
begin
    df_orig = DataFrame(A = 1:5, B = rand(5), C = ["x", "y", "z", "w", "v"])
    
    filename = tempname(suffix=".jld2")

    CSV.write(filename, df_orig)
    
    df_loaded = CSV.read(filename, DataFrame)

    @assert df_orig == df_loaded
end

#===========================================================================================
12. Аргументы запуска Julia
=#

#=
Как задать окружение при запуске?

Использование флага --project
julia --project=/путь/к/проекту script.jl
Или активация текущего директория как проекта:
julia --project=. script.jl
=#

#=
Как задать скрипт, который будет выполняться при запуске:
а) из файла .jl
julia script.jl arg1 arg2

б) из текста команды? (см. флаг -e)
julia -e "println(2 + 2)"
julia -E "randn()"
julia -e "using Pkg; Pkg.status()"
=#

#=
После выполнения задания Boids запустить julia из командной строки,
передав в виде аргумента имя gif-файла для сохранения анимации
=#
