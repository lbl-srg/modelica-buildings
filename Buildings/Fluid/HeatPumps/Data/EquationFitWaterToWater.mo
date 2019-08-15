within Buildings.Fluid.HeatPumps.Data;
package EquationFitWaterToWater "WaterToWaterHeatPump"
  extends Modelica.Icons.MaterialPropertiesPackage;

  record Generic_EquationFit "Generic data record for water to water heatpump equation fit method"
    extends Modelica.Icons.Record;

    parameter Modelica.SIunits.HeatFlowRate QCon_heatflow_nominal
     "Nominal condenser heating capacity"
      annotation (Dialog(group="Nominal conditions heating dominated mode"));
    parameter Modelica.SIunits.HeatFlowRate QEva_heatflow_nominal(max=0)
     "Nominal evaporator cooling capacity_negative number"
      annotation (Dialog(group="Nominal conditions cooling dominated mode"));
    parameter Modelica.SIunits.VolumeFlowRate VCon_nominal
     "Nominal condesner volume flow rate"
      annotation (Dialog(group="Nominal conditions heating dominated mode"));
    parameter Modelica.SIunits.VolumeFlowRate VEva_nominal
     "Nominal evaporator volume flow rate"
      annotation (Dialog(group="Nominal conditions cooling dominated mode"));
    parameter Modelica.SIunits.MassFlowRate   mCon_flow_nominal
     "Nominal condenser mass flow rate"
      annotation (Dialog(group="Nominal conditions heating dominated mode"));
    parameter Modelica.SIunits.MassFlowRate   mEva_flow_nominal
     "Nominal evaporator mass flow"
      annotation (Dialog(group="Nominal conditions cooling dominated mode"));
    parameter Modelica.SIunits.Power PCon_nominal_HD
     "Nominal compressor power heating mode"
      annotation (Dialog(group="Nominal conditions heating dominated mode"));
    parameter Modelica.SIunits.Power PEva_nominal_CD
     "Nominal compressor power cooling mode"
      annotation (Dialog(group="Nominal conditions cooling dominated mode"));
   constant Integer nCLR= 5
    "Number of coefficients for Cooling load Ratio "
      annotation (Dialog(group="Equationfit cooling dominated load coefficients"));
   constant Integer nPowR_CD= 5
    "Number of coefficients for Power Ratio"
      annotation (Dialog(group="Equationfit cooling dominated  power coefficients"));
   constant Integer nHLR=5
    "Number of coefficients for HLR "
      annotation (Dialog(group="Equationfit heating dominated load coefficients"));
   constant Integer nPowR_HD=5
    "Number of coefficients for PowR"
      annotation (Dialog(group="Equationfit heating dominated  power coefficients"));
   parameter Real HLRC[nHLR]
    "Heating Load ratio coefficients"
      annotation (Dialog(group="Equationfit heating dominated load coefficients"));
   parameter Real P_HDC[nPowR_HD]
    "Power Ratio coefficients  in heating mode"
      annotation (Dialog(group="Equationfit heating dominated  power coefficients"));
   parameter Real CLRC[nCLR]
    "Cooling Load ratio coefficients"
      annotation (Dialog(group="Equationfit cooling dominated load coefficients"));
   parameter Real P_CDC[nPowR_CD]
    "Power Ratio coefficients in cooling mode"
      annotation (Dialog(group="Equationfit cooling dominated  power coefficients"));
   parameter Modelica.SIunits.Temperature TRef= 10+273.15
    "Reference temperature used to normalize the inlet temperature variables"
      annotation (Dialog(group="Refrence condition"));
  annotation (
    defaultComponentName="datPer",
    defaultComponentPrefixes="parameter",
    Documentation(info =        "<html>
<p>This record is used as a template for performance data
for the heatpump model
<a href=\"Buildings.Fluid.HeatPumps.EquationFitWaterToWater\">
Buildings.Fluid.HeatPumps.EquationFitWaterToWater</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
June 19, 2019 by Hagar Elarga:<br/>
First implementation.
</li>
</ul>
</html>"));

  end Generic_EquationFit;

record Trane_Axiom_EXW240 =
 Buildings.Fluid.HeatPumps.Data.EquationFitWaterToWater.Generic_EquationFit (
      TRef=10 + 273.15,
      QCon_heatflow_nominal=77000.00,
      QEva_heatflow_nominal=-55680.00,
      VCon_nominal=0.001893,
      mCon_flow_nominal=1000*0.001893,
      VEva_nominal=0.001893,
      mEva_flow_nominal=1000*0.001893,
      PCon_nominal_HD=18000,
      PEva_nominal_CD=14244.44,
      HLRC={-4.23,-1.24,6.28,0.01,0.08},
      CLRC={-5.79235417,9.83800467,-3.19795605,0.32498894,0.043752306918433},
      P_HDC={-5.55,5.08,1.01,-0.04,0.00},
      P_CDC={-6.37109639,1.27560526,5.81780490,0.03132874,-0.082990443216406})
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
  record EnergyPlus_HeatPump =
   Buildings.Fluid.HeatPumps.Data.EquationFitWaterToWater.Generic_EquationFit (
      TRef=10 + 273.15,
      QCon_heatflow_nominal=39040.00,
      QEva_heatflow_nominal=-39890.91,
      VCon_nominal=0.001893,
      mCon_flow_nominal=1000*0.001893,
      VEva_nominal=0.001893,
      mEva_flow_nominal=1000*0.001893,
      PCon_nominal_HD=4790,
      PEva_nominal_CD=4790,
      HLRC={-3.33491153,-0.51451946,4.51592706,0.01797107,0.155797661},
      CLRC={-1.52030596,3.46625667,-1.32267797,0.09395678,0.038975504},
      P_HDC={-4.59564386,0.96265085,4.69489229,0.2501669,-1.20132665},
      P_CDC={-4.59564386,0.96265085,4.69489229,0.02501669,-0.20132665})
        "EnergyPlus_HeatPump"
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)),
    defaultComponentName="EPdataHP",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                   "<html>
This data corresponds to the EnergyPlus example file <code>GSHPSimple-GLHE.idf</code>
from EnergyPlus 9.1, with a nominal cooling capacity of <i>39890</i> Watts and 
nominal heating capacity of <i>39040</i> Watt.


</html>"));
annotation(preferredView="info",
 Documentation(info="<html>
<p>
Package with performance data for water to water heatpumps.
</p>
</html>",
revisions="<html>
<ul>
<li>
June 19, 2019, by Hagar Elarga <br/>
First implementation.
</li>
</ul>
</html>"));
end EquationFitWaterToWater;
