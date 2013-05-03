within Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.BaseClasses;
block CoolingCapacity
  "Calculates heating and cooling capacities for different stages"
  extends
    Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.BaseClasses.InputInterface;
  parameter
    Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.Data.BaseClasses.CoolingMode
    cooMod "Performance data";

  output Modelica.SIunits.Temperature T_nominal "Reference temperature";
//   output Modelica.SIunits.MassFlowRate m1_flow_nominal
//     "Medium1 nominal mass flow rate";
//   output Modelica.SIunits.MassFlowRate m2_flow_nominal
//     "Medium2 nominal mass flow rate";
  output Real T1_NonDim "Medium1 non-dimensional temperature";
  output Real T2_NonDim "Medium2 non-dimensional temperature";
  output Real V1_flow_NonDim "Medium1 non-dimensional volumetric flow rate";
  output Real V2_flow_NonDim "Medium2 non-dimensional volumetric flow rate";
  output Real NonDimVarSet[4]={T1_NonDim,T2_NonDim,V1_flow_NonDim,V2_flow_NonDim}
    "Set of non-dimensional variables";

  output Real fra1(min=0, max=1)
    "Fraction for zero and reverse flow condition on load side";
  output Real fra2(min=0, max=1)
    "Fraction for zero and reverse flow condition on source side";
  output Real fra(min=0, max=1) "Fraction for zero and reverse flow condition";
  constant Real deltaV_flow_NonDim=0.0001
    "Minimum non-dimensional volumetric flow rate below which heat transfer stops";
                                          //below 0.0001 fra1 and fra2 are not 0 and 1
    //delta for non-dimensional variable which varies between 0 and 1 thus non relative value

  Modelica.Blocks.Interfaces.RealOutput QCoo1_flow[cooMod.nSta](unit="W")
    "Vol1 heat transfer rate"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));

  Modelica.Blocks.Interfaces.RealOutput PCoo[cooMod.nSta](quantity="Power", unit="W")
    "Electrical power consumed by the compressor"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}},
                                                                     rotation=0)));

equation
  if mode == 2 then
  //Determine nominal temperature to be used
    T_nominal= cooMod.T_nominal;
  //Determine nominal mass flow rates to be used
//     m1_flow_nominal= cooMod.m1_flow_nominal;
//     m2_flow_nominal= cooMod.m2_flow_nominal;
  //Calculate non-dimensional variables
    T1_NonDim= T1/T_nominal;
    T2_NonDim= T2/T_nominal;
  // fixme: multiply by density fraction
    V1_flow_NonDim= (m1_flow/cooMod.m1_flow_nominal)*(rho[3]/rho[1]);
    V2_flow_NonDim= (m2_flow/cooMod.m2_flow_nominal)*(rho[4]/rho[2]);

  //Fractions for zero and reverse mass flow rate
    fra1= Buildings.Utilities.Math.Functions.spliceFunction(
      pos=1,
      neg=0,
      x=V1_flow_NonDim - deltaV_flow_NonDim,
      deltax=deltaV_flow_NonDim);
    fra2= Buildings.Utilities.Math.Functions.spliceFunction(
      pos=1,
      neg=0,
      x=V2_flow_NonDim - deltaV_flow_NonDim,
      deltax=deltaV_flow_NonDim);
    fra= fra1*fra2;

    for iSta in 1:cooMod.nSta loop
    //Cooling mode calculations
      QCoo1_flow[iSta] =
        Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.BaseClasses.linearFourVariables(
         x=NonDimVarSet, a=cooMod.cooPer[iSta].cooCap)*cooMod.cooPer[iSta].Q_flow_nominal
        *fra;
      PCoo[iSta] =
        Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.BaseClasses.linearFourVariables(
         x=NonDimVarSet, a=cooMod.cooPer[iSta].cooP)*cooMod.cooPer[iSta].P_nominal
        *fra;
    end for;
  else //Compressor off condition
    T_nominal= 273.15;
//     m1_flow_nominal= 0;
//     m2_flow_nominal= 0;
    T1_NonDim= 0;
    T2_NonDim= 0;
    V1_flow_NonDim= 0;
    V2_flow_NonDim= 0;
    QCoo1_flow= fill(0, cooMod.nSta);
    PCoo= fill(0, cooMod.nSta);
    fra1= 0;
    fra2= 0;
    fra= 0;
  end if;
  annotation (defaultComponentName="cooCap", Diagram(graphics), Documentation(info="<html>
<p>
This block calculates the rate of cooling for the water on load side.
The model is based on four non-dimensional variables to calculate the heat pump performance. 
For more details about the model refer to dissertation by Tang (2005)</p>
<p>
The equations used to calcualte the performance are:
<p align=\"center\" style=\"font-style:italic;\">
  Q&#775;<sub> c </sub>  &frasl;  Q&#775;<sub> c, nom </sub> = a<sub>1</sub>
      + a<sub>2</sub> (T<sub>l,in </sub> &frasl;  T<sub>nom </sub>)
      + a<sub>3</sub> (T<sub>s,in </sub> &frasl;  T<sub>nom </sub>)
      + a<sub>4</sub> (V&#775;<sub>l,in </sub> &frasl;  V&#775;<sub>l,nom </sub>)
      + a<sub>5</sub> (V&#775;<sub>s,in </sub> &frasl;  V&#775;<sub>s,nom </sub>)</p>
<p align=\"center\" style=\"font-style:italic;\">
  P<sub> c </sub>  &frasl;  P<sub> c, nom </sub> = b<sub>1</sub>
      + b<sub>2</sub> (T<sub>l,in </sub> &frasl;  T<sub>nom </sub>)
      + b<sub>3</sub> (T<sub>s,in </sub> &frasl;  T<sub>nom </sub>)
      + b<sub>4</sub> (V&#775;<sub>l,in </sub> &frasl;  V&#775;<sub>l,nom </sub>)
      + b<sub>5</sub> (V&#775;<sub>s,in </sub> &frasl;  V&#775;<sub>s,nom </sub>)</p>
where, subcripts <i>l</i> stands for load side values, 
<i>s</i> stands for source side values, 
<i>nom</i> stands for nominal values, 
<i>c</i> stands for cooling and the coefficients 
<i>a<sub>1</sub></i> to <i>a<sub>5</sub></i>, <i>b<sub>1</sub></i> to <i>b<sub>5</sub></i> are calculated using manufacturers data.  
</p>
<h4>References</h4>
<p>
Tang, Chin Chien.
Modeling Packaged Heat Pumps in a Quasi-Steady State Energy Simulation Program.
<i>Oklahoma State University</i>, Stillwater, Oklahoma, May, 2005.
</p>
</html>",
revisions="<html>
<ul>
<li>
Jan 10, 2013 by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul>

</html>"),Icon(graphics), Diagram(graphics));
end CoolingCapacity;
