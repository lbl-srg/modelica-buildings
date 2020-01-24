within Buildings.Fluid.HeatPumps.Data.EquationFitReversible;
record Trane_Axiom_EXW240 =
 Buildings.Fluid.HeatPumps.Data.EquationFitReversible.Generic (
    dpHeaSou_nominal = 33530,
    dpHeaLoa_nominal = 32460,
    hea(
      TRefLoa = 53 + 273.15,
      TRefSou = 18 + 273.15,
      Q_flow = 77000.00,
      P = 18000,
      mSou_flow = 1.893,
      mLoa_flow = 1.893,
      coeQ = {-4.23,-1.24,6.28,0.01,0.08},
      coeP = {-5.55,5.08,1.01,-0.04,0.00}),
    coo(
      TRefSou = 28 + 273.15,
      TRefLoa =  12 + 273.15,
      Q_flow = -55680.00,
      P = 14244.44,
      coeQ = {-5.79235417,9.83800467,-3.19795605,0.32498894,0.043752306918433},
      coeP = {-6.37109639,1.27560526,5.81780490,0.03132874,-0.082990443216406}))
   "Reverse heat pump Trane Axiom EXW240"
annotation (
  defaultComponentName="per",
  defaultComponentPrefixes="parameter",
  Documentation(info =   "<html>
  <p>
Performance data for reverse heat pump model.
This data corresponds to the following
<a href=\"https://www.trane.com/content/dam/Trane/Commercial/global/products-systems/equipment/unitary/water-source-heat-pumps/water-to-water-wshp/WSHP-PRC022E-EN_08152017.pdf\">https://www.trane.com/wshp.pdf</a>
catalog data.
</p>
<pre>
    Trane EXW 70kW/4.11COP,  !- Name
    77000,                   !- Reference Heating Capacity {W}
    55680,                   !- Reference Cooling Capacity {W}
    4.10,                    !- Reference COP {W/W}
    13.5,                    !- Refrence EER{BTUh/W}
    0.0018,                  !- Reference Evaporator Water Flow Rate {m3/s}
    0.0018,                  !- Reference Condenser Water Flow Rate {m3/s}
</pre>
</html>",
revisions="<html>
<ul>
<li>
September 16, 2019 by Michael Wetter:<br/>
Refactored implementation.
</li>
<li>
June 19, 2019 by Hagar Elarga:<br/>
First implementation.
</li>
</ul>
</html>"));
