//+------------------------------------------------------------------+
//|                                                       SpaWink EA |
//|                                                    Copyright 2023 |
//+------------------------------------------------------------------+
#property link      "https://spawink.com"
#property version   "1.4"
#property strict

//+------------------------------------------------------------------+
//| Classes and Functions                                           |
//+------------------------------------------------------------------+

// Portfolio Optimization Class
class PortfolioOptimization
{
    private:
        int numAssets;
        double* expectedReturns;
        double* variances;
        double** covariances;

    public:
        PortfolioOptimization(int numAssets, double* expectedReturns, double* variances, double** covariances);
        ~PortfolioOptimization();

        double* optimizePortfolio(double targetReturn);
};

// Constructor for Portfolio Optimization Class
PortfolioOptimization::PortfolioOptimization(int numAssets, double* expectedReturns, double* variances, double** covariances)
{
    this->numAssets = numAssets;
    this->expectedReturns = new double[numAssets];
    this->variances = new double[numAssets];
    this->covariances = new double*[numAssets];
    for (int i = 0; i < numAssets; i++)
    {
        this->expectedReturns[i] = expectedReturns[i];
        this->variances[i] = variances[i];
        this->covariances[i] = new double[numAssets];
        for (int j = 0; j < numAssets; j++)
        {
            this->covariances[i][j] = covariances[i][j];
        }
    }
}

// Destructor for Portfolio Optimization Class
PortfolioOptimization::~PortfolioOptimization()
{
    delete[] expectedReturns;
    delete[] variances;

    for (int i = 0; i < numAssets; i++)
    {
        delete[] covariances[i];
    }
    delete[] covariances;
}

// Optimize Portfolio Function for Portfolio Optimization Class
double* PortfolioOptimization::optimizePortfolio(double targetReturn)
{
    double** inverseCovariances = new double*[numAssets];
    for (int i = 0; i < numAssets; i++)
    {
        inverseCovariances[i] = new double[numAssets];
        for (int j = 0; j < numAssets; j++)
        {
            inverseCovariances[i][j] = covariances[i][j];
        }
    }

    double determinant = 1.0;
    for (int i = 0; i < numAssets; i++)
    {
        for (int j = 0; j < numAssets; j++)
        {
            if (i == j)
            {
                double pivot = inverseCovariances[i][j];
                if (pivot == 0.0)
                {
                    int k = i + 1;
                    while (k < numAssets && inverseCovariances[k][j] == 0.0)
                    {
                        k++;
                    }
                    if (k >= numAssets)
                    {
                        delete[] inverseCovariances;
                        return NULL;
                    }
                    double* temp = inverseCovariances[i];
                    inverseCovariances[i] = inverseCovariances[k];
                    inverseCovariances[k] = temp;
                    pivot = inverseCovariances[i][j];
                    determinant *= -1.0;
                }

                determinant *= pivot;
                for (int k = 0; k < numAssets; k++)
                {
                    inverseCovariances[i][k] /= pivot;
                }
            }
           
