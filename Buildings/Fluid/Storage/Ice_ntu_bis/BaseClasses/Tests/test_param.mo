within Buildings.Fluid.Storage.Ice_ntu_bis.BaseClasses.Tests;
model test_param
Real Ttank(start=273.15+30);
Real Tin = 273.15;

equation
  der(Ttank) * 1000 * 1 * 4184 = - 4184 * 2 * (Ttank-Tin);


end test_param;
