#ifndef OPTIMIZATION_MQH
#define OPTIMIZATION_MQH

enum OptimizationMethod
{
    BRUTE_FORCE = 0,
    GRID_SEARCH = 1,
    PARTICLE_SWARM = 2
};

struct OptimizationResult
{
    double bestProfit;
    double bestParameters[];
};

class ParameterSet
{
    private:
        int numParameters;
        double* parameterValues;
        double* parameterStepSizes;

    public:
        ParameterSet(int numParameters, double* parameterValues, double* parameterStepSizes);
        ~ParameterSet();

        double getParameter(int parameterIndex);
        void setParameter(int parameterIndex, double value);
        double getStepSize(int parameterIndex);
};

class Optimizer
{
    private:
        OptimizationMethod method;
        int numParameters;
        double* parameterValues;
        double* parameterStepSizes;

    public:
        Optimizer(OptimizationMethod method, int numParameters, double* parameterValues, double* parameterStepSizes);
        ~Optimizer();

        OptimizationResult optimize(double (*fitnessFunction)(ParameterSet parameters));
};

#endif
