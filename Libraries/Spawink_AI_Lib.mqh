//+------------------------------------------------------------------+
//|                                                         SpaWink AI|
//|                                                       Copyright 2023|
//+------------------------------------------------------------------+
#property strict

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

// Backpropagation Function for Neural Network Class
void NeuralNetwork::train(double* input, double* output, double learningRate, int numEpochs)
{
for (int epoch = 0; epoch < numEpochs; epoch++)
{
// Feed forward
double* layerOutputs[numLayers];
layerOutputs[0] = new double[layerSizes[0]];
for (int i = 0; i < layerSizes[0]; i++)
{
layerOutputs[0][i] = input[i];
}

    for (int i = 1; i < numLayers; i++)
    {
        layerOutputs[i] = new double[layerSizes[i]];
        for (int j = 0; j < layerSizes[i]; j++)
        {
            double weightedSum = 0.0;
            for (int k = 0; k < layerSizes[i-1]; k++)
            {
                weightedSum += layerOutputs[i-1][k] * weights[i-1][j*layerSizes[i-1]+k];
            }
            weightedSum += biases[i-1][j];
            layerOutputs[i][j] = 1.0 / (1.0 + exp(-weightedSum));
        }
    }

    double* networkOutput = layerOutputs[numLayers-1];

    // Backpropagation
    double* errors = new double[layerSizes[numLayers-1]];
    for (int i = 0; i < layerSizes[numLayers-1]; i++)
    {
        errors[i] = output[i] - networkOutput[i];
    }

    for (int i = numLayers-2; i >= 0; i--)
    {
        double* layerError = new double[layerSizes[i+1]];
        for (int j = 0; j < layerSizes[i+1]; j++)
        {
            double errorGradient;
            if (i == numLayers-2)
            {
                errorGradient = networkOutput[j] * (1 - networkOutput[j]) * errors[j];
            }
            else
            {
                errorGradient = layerOutputs[i+1][j] * (1 - layerOutputs[i+1][j]);
                double weightedErrorSum = 0.0;
                for (int k = 0; k < layerSizes[i+2]; k++)
                {
                    weightedErrorSum += weights[i+1][k*layerSizes[i+1]+j] * layerError[k];
                }
                errorGradient *= weightedErrorSum;
            }
            layerError[j] = errorGradient;
            biases[i][j] += learningRate * errorGradient;
        }

        for (int j = 0; j < layerSizes[i]; j++)
        {
            for (int k = 0; k < layerSizes[i+1]; k++)
            {
                double outputValue;
                if (i == 0)
                {
                    outputValue = input[j];
                }
                else
                {
                    outputValue = layerOutputs[i-1][j];
                }
                double weightDelta = learningRate * layerError[k] * outputValue;
                weights[i][k*layerSizes[i]+j] += weightDelta;
            }
        }

        delete[] layerError;
    }

    for (int i = 0; i < numLayers; i++)
    {
        delete[] layerOutputs[i];
    }

    delete[] errors;
}
}

