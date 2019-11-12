using System;
using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.Simulation.Simulators;

namespace Quantum.QSharpGrammer
{
    class Driver
    {
        static void Main(string[] args)
        {
            using (var qsim = new QuantumSimulator())
            {
                GrammerExample.Run(qsim).Wait();
                Arrays.Run(qsim).Wait();
            }
        }
    }
}