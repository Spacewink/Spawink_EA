//+------------------------------------------------------------------+
//|                                                      SpaWink AI  |
//|                                                    Copyright 2023|
//+------------------------------------------------------------------+
#property link      "https://spawink.com"
#property version   "1.0"
#property strict

//+------------------------------------------------------------------+
//| Classes and Functions                                           |
//+------------------------------------------------------------------+

// Neural Network Class
class NeuralNetwork
{
    private:
        int numLayers;
        int* layerSizes;
        double** weights;
        double** biases;

    public:
        NeuralNetwork(int numLayers, int* layerSizes);
        ~NeuralNetwork();

        double* feedForward(double* input);
        void train(double* input, double* output, double learningRate, int numEpochs);
};

// Constructor for Neural Network Class
NeuralNetwork::NeuralNetwork(int numLayers, int* layerSizes)
{
    this->numLayers = numLayers;
    this->layerSizes = new int[numLayers];
    for (int i = 0; i < numLayers; i++)
    {
        this->layerSizes[i] = layerSizes[i];
    }

    this->weights = new double*[numLayers-1];
    for (int i = 0; i < numLayers-1; i++)
    {
        this->weights[i] = new double[layerSizes[i+1] * layerSizes[i]];
    }

    this->biases = new double*[numLayers-1];
    for (int i = 0; i < numLayers-1; i++)
    {
        this->biases[i] = new double[layerSizes[i+1]];
    }
}

// Destructor for Neural Network Class
NeuralNetwork::~NeuralNetwork()
{
    delete[] layerSizes;

    for (int i = 0; i < numLayers-1; i++)
    {
        delete[] weights[i];
    }
    delete[] weights;

    for (int i = 0; i < numLayers-1; i++)
    {
        delete[] biases[i];
    }
    delete[] biases;
}

// Feed Forward Function for Neural Network Class
double* NeuralNetwork::feedForward(double* input)
{
    double* output = new double[layerSizes[numLayers-1]];
    for (int i = 0; i < layerSizes[numLayers-1]; i++)
    {
        output[i] = 0.0;
    }

    double* tempOutput = new double[layerSizes[0]];
    for (int i = 0; i < layerSizes[0]; i++)
    {
        tempOutput[i] = input[i];
    }

    for (int i = 0; i < numLayers-1; i++)
    {
        double* layerOutput = new double[layerSizes[i+1]];
        for (int j = 0; j < layerSizes[i+1]; j++)
        {
            layerOutput[j] = 0.0;
            for (int k = 0; k < layerSizes[i]; k++)
            {
                layerOutput[j] += tempOutput[k] * weights[i][j*layerSizes[i]+k];
            }
            layerOutput[j] += biases[i][j];
            layerOutput[j] = 1.0 / (1.0 + exp(-layerOutput[j]));
        }
        delete[] tempOutput;
        tempOutput = layerOutput;
    }

    for (int i = 0; i < layerSizes[numLayers-1]; i++)
    {
        output[i] = tempOutput[i];
    }

    delete[] tempOutput;
    return output;
}

// Train Function for Neural Network Class
void NeuralNetwork::train(double* input, double* output, double learningRate, int numEpochs)
{
double** layerOutputs = new double*[numLayers];
for (int i = 0; i < numLayers; i++)
{
layerOutputs[i] = new double[layerSizes[i]];
}

css
Copy code
double** layerInputs = new double*[numLayers];
for (int i = 0; i < numLayers; i++)
{
    layerInputs[i] = new double[layerSizes[i]];
}

double** layerWeightsGradient = new double*[numLayers-1];
for (int i = 0; i < numLayers-1; i++)
{
    layerWeightsGradient[i] = new double[layerSizes[i+1] * layerSizes[i]];
}

double** layerBiasesGradient = new double*[numLayers-1];
for (int i = 0; i < numLayers-1; i++)
{
    layerBiasesGradient[i] = new double[layerSizes[i+1]];
}

double* layerError = new double[layerSizes[numLayers-1]];

for (int epoch = 0; epoch < numEpochs; epoch++)
{
    // Forward Pass
    feedForward(input);

    for (int i = 0; i < numLayers; i++)
    {
        for (int j = 0; j < layerSizes[i]; j++)
        {
            layerInputs[i][j] = 0.0;
        }
    }

    for (int i = 0; i < numLayers-1; i++)
    {
        for (int j = 0; j < layerSizes[i+1]; j++)
        {
            double weightedSum = 0.0;
            for (int k = 0; k < layerSizes[i]; k++)
            {
                weightedSum += layerOutputs[i][k] * weights[i][j*layerSizes[i]+k];
            }
            layerOutputs[i+1][j] = 1.0 / (1.0 + exp(-1.0 * (weightedSum + biases[i][j])));
        }
    }

    for (int i = 0; i < layerSizes[numLayers-1]; i++)
    {
        layerError[i] = output[i] - layerOutputs[numLayers-1][i];
    }

// Backward Pass
for (int i = numLayers-1; i >= 1; i--)
{
for (int j = 0; j < layerSizes[i]; j++)
{
double errorGradient = 0.0;
if (i == numLayers-1)
{
errorGradient = output[j] - desiredOutput[j];
errors[i][j] = errorGradient;
}
else
{
for (int k = 0; k < layerSizes[i+1]; k++)
{
errorGradient += errors[i+1][k] * weights[i][k*layerSizes[i]+j];
}
}


    if (i != 1)
    {
        layerInputs[i-1][j] = layerOutputs[i-2][j];
    }
    else
    {
        layerInputs[i-1][j] = input[j];
    }

    double derivative = layerOutputs[i-1][j] * (1.0 - layerOutputs[i-1][j]);

    errors[i-1][j] = errorGradient * derivative;
}
}

// Update Weights and Biases
for (int i = 0; i < numLayers-1; i++)
{
for (int j = 0; j < layerSizes[i+1]; j++)
{
for (int k = 0; k < layerSizes[i]; k++)
{
double weightUpdate = 0.0;
for (int p = 0; p < numTrainingSamples; p++)
{
weightUpdate += errors[i+1][j] * layerOutputs[i][k] / numTrainingSamples;
}
weights[i][j*layerSizes[i]+k] -= learningRate * weightUpdate;
}
double biasUpdate = 0.0;
for (int p = 0; p < numTrainingSamples; p++)
{
biasUpdate += errors[i+1][j] / numTrainingSamples;
}
biases[i][j] -= learningRate * biasUpdate;
}
}
