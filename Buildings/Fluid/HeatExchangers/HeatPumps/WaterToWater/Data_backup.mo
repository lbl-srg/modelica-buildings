within Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater;
package Data_backup "Performance data record for Heat Pumps"
  extends Modelica.Icons.MaterialPropertiesPackage;
//fixme: backup created for original package
//to restore, rename Data
  record HPData "Data record for Water to Water Heat Pump"
    extends Modelica.Icons.Record;
    parameter
      Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.Data_backup.BaseClasses.CoolingMode
      cooMod "Cooling mode data"
      annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
    parameter
      Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.Data_backup.BaseClasses.HeatingMode
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

  package BaseClasses "Data baseclasses for Water source heatpumps "
    extends Modelica.Icons.BasesPackage;

    record CoolingMode
      "Base data record for Water to Water Heat Pump in cooling mode"
      extends Modelica.Icons.Record;

      parameter Integer nSta(min=0)
        "Total number of stages in cooling mode operation";
        // 0 stages if heat pump is only used for heating purpose

      parameter
        Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.Data_backup.BaseClasses.CoolingPerformance
        cooPer[nSta] "Cooling mode performance data"
        annotation (Placement(transformation(extent={{0,0},{20,20}})));

    //-----------------------------Cooling mode nominal condition-----------------------------//

      parameter Modelica.SIunits.Temperature T_nominal=273.15+10
        "Reference cooling mode temperature"
          annotation(Dialog(tab="General",group="Cooling mode nominal condition"));

      parameter Modelica.SIunits.MassFlowRate m1_flow_nominal
        "Cooling mode load side nominal water mass flow rate"
        annotation (Dialog(group="Cooling mode nominal condition"));

      parameter Modelica.SIunits.MassFlowRate m2_flow_nominal
        "Cooling mode source side nominal water mass flow rate"
        annotation (Dialog(group="Cooling mode nominal condition"));

    //   parameter Modelica.SIunits.Pressure p_nominal=101325 "Nominal pressure"
    //     annotation(Dialog(tab="General",group="Cooling mode nominal condition"));
      annotation (preferedView="info",defaultComponentName="cooMod",
      Documentation(info="<html>
This is data record for Water to Water Heat Pump in cooling mode. 
</html>",
    revisions="<html>
<ul>
<li>
January 12, 2013, by Kaustubh Phalak:<br>
First implementation.
</li>
</ul>
</html>"));

    end CoolingMode;

    record CoolingPerformance
      "Base performance data record for water to water heat pump in cooling mode"
      extends Modelica.Icons.Record;
      parameter Modelica.SIunits.AngularVelocity spe(displayUnit="1/min")
        "Rotational speed";
    //-----------------------------Cooling mode nominal condition-----------------------------//
      parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal(max=0)
        "Reference cooling capacity (negative number)"
        annotation (Dialog(group="Cooling mode nominal condition"));

      parameter Modelica.SIunits.Power P_nominal
        "Rated power consumed by the unit in cooling mode"
        annotation (Dialog(group="Cooling mode nominal condition"));

    //---------------------Cooling mode non-dimensional performance curves----------------------//
      parameter Real cooCap[5]
        "Coefficients for non-dimensional cooling capacity curve"
        annotation (Dialog(group="Cooling mode performance curves"));

      parameter Real cooP[5]
        "Coefficients for non-dimensional power consumption curve (in cooling mode)"
        annotation (Dialog(group="Cooling mode performance curves"));

      annotation (preferedView="info",defaultComponentName="cooPer",
      Documentation(info="<html>
This is performance data record for Water to Water Heat Pump in cooing mode. 
</html>",
    revisions="<html>
<ul>
<li>
January 12, 2013, by Kaustubh Phalak:<br>
First implementation.
</li>
</ul>
</html>"),
        Icon(graphics={
            Text(
              extent={{-95,53},{-12,-2}},
              lineColor={0,0,255},
              textString="Q"),
            Text(
              extent={{7,55},{90,0}},
              lineColor={0,0,255},
              textString="%Q_flow_nominal"),
            Text(
              extent={{-105,-9},{-48,-48}},
              lineColor={0,0,255},
              textString="T"),
            Text(
              extent={{2,-16},{94,-38}},
              lineColor={0,0,255},
              textString="%T_nominal"),
            Text(
              extent={{-95,-49},{-12,-104}},
              lineColor={0,0,255},
              textString="m"),
            Text(
              extent={{7,-53},{84,-94}},
              lineColor={0,0,255},
              textString="%m1_flow_nominal")}));

    end CoolingPerformance;

    record HeatingMode
      "Data record for water to water heat pump in heating mode"
      extends Modelica.Icons.Record;

      parameter Integer nSta(min=0)
        "Total number of stages in heating mode operation";
        // 0 stages if heat pump is only used for cooling purpose

      parameter
        Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.Data_backup.BaseClasses.HeatingPerformance
        heaPer[nSta] "Heating mode performance data"
        annotation (Placement(transformation(extent={{-40,0},{-20,20}})));

    //-----------------------------Heating mode nominal condition-----------------------------//

      parameter Modelica.SIunits.Temperature T_nominal=273.15+10
        "Reference heating mode temperature"
        annotation(Dialog(tab="General",group="Heating mode nominal condition"));

      parameter Modelica.SIunits.MassFlowRate m1_flow_nominal
        "Heating mode load side nominal water mass flow rate"
        annotation (Dialog(group="Heating mode nominal condition"));

      parameter Modelica.SIunits.MassFlowRate m2_flow_nominal
        "Heating mode source side nominal water mass flow rate"
        annotation (Dialog(group="Heating mode nominal condition"));

    //   parameter Modelica.SIunits.Pressure p_nominal=101325 "Nominal pressure"
    //     annotation(Dialog(tab="General",group="Cooling mode nominal condition"));

      annotation (preferedView="info",defaultComponentName="heaMod",
      Documentation(info="<html>
This is data record for Water to Water Heat Pump in heating mode. 
</html>",
    revisions="<html>
<ul>
<li>
January 12, 2013, by Kaustubh Phalak:<br>
First implementation.
</li>
</ul>
</html>"));

    end HeatingMode;

    record HeatingPerformance
      "Base performance data record for water to water heat pump in heating mode"
      extends Modelica.Icons.Record;
      parameter Modelica.SIunits.AngularVelocity spe(displayUnit="1/min")
        "Rotational speed";

    //-----------------------------Heating mode nominal condition-----------------------------//
      parameter Modelica.SIunits.HeatFlowRate QHea_flow_nominal(min=0)
        "Reference heating capacity"
        annotation (Dialog(group="Heating mode nominal condition"));

      parameter Modelica.SIunits.Power PHea_nominal
        "Rated power consumed by the unit in heating mode"
        annotation (Dialog(group="Heating mode nominal condition"));

    //-----------------------------Heating mode non-dimensional performance curves-----------------------------//
      parameter Real heaCap[5]
        "Coefficients for non-dimensional heating capacity curve"
        annotation (Dialog(group="Heating mode performance curves"));

      parameter Real heaP[5]
        "Coefficients for non-dimensional power consumption curve (in heating mode)"
        annotation (Dialog(group="Heating mode performance curves"));

      annotation (preferedView="info",defaultComponentName="heaPer",
      Documentation(info="<html>
This is data performance record for Water to Water Heat Pump in heating mode. 
</html>",
    revisions="<html>
<ul>
<li>
January 12, 2013, by Kaustubh Phalak:<br>
First implementation.
</li>
</ul>
</html>"),
        Icon(graphics={
            Text(
              extent={{-95,53},{-12,-2}},
              lineColor={0,0,255},
              textString="Q"),
            Text(
              extent={{7,55},{90,0}},
              lineColor={0,0,255},
              textString="%QHea_flow_nominal"),
            Text(
              extent={{-105,-9},{-48,-48}},
              lineColor={0,0,255},
              textString="T"),
            Text(
              extent={{2,-16},{94,-38}},
              lineColor={0,0,255},
              textString="%T_nominal"),
            Text(
              extent={{-95,-49},{-12,-104}},
              lineColor={0,0,255},
              textString="m"),
            Text(
              extent={{7,-53},{84,-94}},
              lineColor={0,0,255},
              textString="%m1_flow_nominal")}));

    end HeatingPerformance;
  end BaseClasses;
annotation (preferedView="info", Documentation(info="<html>
This package contains performance data for water source heat pump model.
</html>"));
end Data_backup;
