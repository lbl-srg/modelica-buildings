within Buildings.Fluid.HeatPumps.Data.EquationFitWaterToWater;
record Trane_Axiom_EXW240 =
 Buildings.Fluid.HeatPumps.Data.EquationFitWaterToWater.Generic (
    TRefHeaCon=53 + 273.15,
    TRefHeaEva=18 + 273.15,
    TRefCooCon=28 + 273.15,
    TRefCooEva=12 + 273.15,
    QCon_flow_nominal=77000.00,
    QEva_flow_nominal=-55680.00,
    mCon_flow_nominal=1000*0.001893,
    mEva_flow_nominal=1000*0.001893,
    PH_nominal=18000,
    PC_nominal=14244.44,
    HLRC={-4.23,-1.24,6.28,0.01,0.08},
    CLRC={-5.79235417,9.83800467,-3.19795605,0.32498894,0.043752306918433},
    PCH={-5.55,5.08,1.01,-0.04,0.00},
    PCC={-6.37109639,1.27560526,5.81780490,0.03132874,-0.082990443216406})
    "Water source HeatPump Trane_Axiom_EXW240"
annotation (
  defaultComponentName="dataHP",
  defaultComponentPrefixes="parameter",
  Documentation(info =   "<html>

  <p>
Performance data for HeatPump model.
This data corresponds to the following<a href=\"https://www.trane.com/content/dam/Trane/Commercial/global/products-systems/equipment/unitary/water-source-heat-pumps/water-to-water-wshp/WSHP-PRC022E-EN_08152017.pdf\"> https://www.trane.com/wshp.pdf</a> catalog data.
</p>
<pre>
Water to water HeatPump,
    Trane EXW 70kW/4.11COP,  !- Name
    77000,                   !- Reference Heating Capacity {W}
    4.10,                    !- Reference COP {W/W}
    0.0018,                  !- Reference Evaporator Water Flow Rate {m3/s}
    0.0018,                  !- Reference Condenser Water Flow Rate {m3/s}
    55680,                   !- Reference Cooling Capacity {W}
    13.5,                    !- Refrence EER{BTUh/W}
    </pre>
<p>
The methodology involved using the generalized least square method to create a set of performance
coefficients based on (J.Hui 2002, S.Arun. 2004 and C.Tang 2004).
</p>
<h4>References</h4>
<p>
C.C Tang, Equation fit based models of water source heat pumps.Master Thesis. Oklahoma State University, Oklahoma, USA. 2005.
</p>
</html>",
revisions="<html>
<ul>
<li>
June 19, 2019 by Hagar Elarga:<br/>
First implementation.
</li>
</ul>
</html>"));
