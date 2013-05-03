within Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.Data;
record HPData "Data record for Water to Water Heat Pump"
  extends Modelica.Icons.Record;
  parameter
    Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.Data.BaseClasses.CoolingMode
    cooMod "Cooling mode data"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  parameter
    Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.Data.BaseClasses.HeatingMode
    heaMod(nSta=1) "Heating mode data"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  annotation (preferedView="info",
defaultComponentName="datHP", Documentation(info="<html>
<p>
This record declares the performance data for the Water to Water Heat Pump models.
The performance data are structured as follows:
</p>
<p>
Each heat pump data record includes heating mode, <code>heaMod</code>
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.Data.BaseClasses.HeatingMode\">
Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.Data.BaseClasses.HeatingMode</a>
and cooling mode, <code>cooMod</code>
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.Data.BaseClasses.CoolingMode\">
Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.Data.BaseClasses.CoolingMode</a>
data. These record have following parameters: 
</p>
<p>
<pre>
  nSta             - Number of stages. Set to 1 for single speed coil, 
                     2 for dual-speed (or dual stage coils), etc.
  T_nominal        - Nominal temperature, default 283.15K.
  m1_flow_nominal  - Medium1 nominal mass flow rate.
  m2_flow_nominal  - Medium2 nominal water mass flow rate
  cooPer/heaPer    - Array of records with one performance curve for each stage for each mode of operation.
</pre>
</p>
<p>
Each element of the array <code>cooPer and heaPer</code> has the following data.
</p>
<p>
<pre>
    spe            - Rotational speed for the respective stage.
                     (This is only used for variable speed coils to interpolate for 
                     intermediate speeds).
    Q_flow_nominal - Total rate of heating/cooling at nominal conditions.
    P_nominal      - Power consumed by the unit at nominal conditions.
    cooCap/heaCap  - Coefficients of polynomial for heating/cooling capacity 
                     as a function of temperature and volumetric mass flow rate.
    cooP/heaP      - Coefficients of polynomial for Power consumtion 
                     as a function of temperature and volumetric mass flow rate.
</pre>
</p>
<p>
Same data record can be used if the heatpump is operated in only one mode. 
Also each mode can have different number of stages i.e. <code>nSta</code> for each 
mode of operation can be diferent.
</p>
<h4>Heat pump performance coefficients</h4>
<p>
The steady-state total rate of heating or cooling and the power consumed by the compressor are
computed using polynomials explained in
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.BaseClasses.CoolingCapacity\">
Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.BaseClasses.CoolingCapacity</a> and 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.BaseClasses.HeatingCapacity\">
Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.BaseClasses.HeatingCapacity</a>.
Coefficients used in these polynomials are as follows:
<p>
<pre>
  <i>a<sub>1</sub></i> to <i>a<sub>5</sub></i>        - Coefficients to calculate cooling capacity. 
  <i>b<sub>1</sub></i> to <i>b<sub>5</sub></i>        - Coefficients to calculate power consumption during cooling operation.
  <i>c<sub>1</sub></i> to <i>c<sub>5</sub></i>        - Coefficients to calculate heating capacity.
  <i>d<sub>1</sub></i> to <i>d<sub>5</sub></i>        - Coefficients to calculate power consumption during heating operation.
</pre>
</p>
These are calculated using manufacturers data. 
</p>

</html>",
revisions="<html>
<ul>
<li>
January 16, 2013, by Kaustubh Phalak:<br>
First implementation.
</li>
</ul>
</html>"));

end HPData;
