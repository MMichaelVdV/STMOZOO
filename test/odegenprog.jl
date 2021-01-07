@testset "ODEGenProg" begin

    using STMOZOO.ODEGenProg

    grammar_1D = define_grammar_1D()
    grammar_2D = define_grammar_2D()

    S = ExprRules.SymbolTable(grammar_1D)
    S_2D = ExprRules.SymbolTable(grammar_2D)
         
    @testset "odegenprog" begin

    @test grammar_1D isa Grammar
    @test grammar_2D isa Grammar

    rulenode_1D = rand(RuleNode, grammar_1D, :R, 10)
    rulenode_2D = rand(RuleNode, grammar_2D, :R, 10)

    @test fitness_0(rulenode_1D, grammar_1D) isa Float64
    @test fitness_1(rulenode_1D, grammar_1D) isa Float64
    @test fitness_2(rulenode_1D, grammar_1D) isa Float64
    @test fitness_3(rulenode_1D, grammar_1D) isa Float64
    @test fitness_4(rulenode_1D, grammar_1D) isa Float64
    @test fitness_2D(rulenode_2D, grammar_2D) isa Float64

    a = rand(RuleNode, grammar_1D, :R, 10)
    b = rand(RuleNode, grammar_1D, :R, 10)
    p = 0.5
    max_depth = 5

    @test mutate(a, p) isa RuleNode
    @test permutate(a, p) isa RuleNode
    @test crossover(p, a, b, max_depth) isa RuleNode
    #@test select(y, S)
    #@test genetic_program(f, population, k_max, S, C, M, max_depth) =#


    #test every fitness function with solution -> 0, expr type
    #test other functions

    #I switched to using the build in GP from the ExprOptimization package with my custom fitness functions because its much faster to evaluate than a manual implementation. 
    #This test evalutates the fitness_test function for ODE f'(x) - f(x) = 0, with boundary condition f(0) = 1. The expected solution is f(x) = exp(x)
    g = ExprOptimization.GeneticProgram(2000,100,5,0.3,0.3,0.4) 
    results_gp = ExprOptimization.optimize(g, grammar_1D, :R, fitness_0)
    @test results_gp.expr isa Expr
    @test results_gp.loss ≈ 0.
    #@test results_gp.expr == :(exp(x))

    @test plot_solution(:(exp(x)),grammar_1D,0.,1.) isa Array{Float64,1}

    end

end