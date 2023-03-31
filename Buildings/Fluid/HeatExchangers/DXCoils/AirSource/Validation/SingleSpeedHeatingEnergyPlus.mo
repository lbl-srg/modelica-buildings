within Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Validation;
model SingleSpeedHeatingEnergyPlus
  "Validation model for single speed DX coil with PLR=1"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air "Medium model";

  parameter Modelica.Units.SI.Power Q_flow_nominal=datCoi.sta[1].nomVal.Q_flow_nominal
    "Nominal power";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=datCoi.sta[1].nomVal.m_flow_nominal
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.PressureDifference dp_nominal=1141
    "Pressure drop at m_flow_nominal";
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    p(displayUnit="Pa") = 101325,
    nPorts=1,
    T=294.15) "Sink"
    annotation (Placement(transformation(extent={{40,-20},{20,0}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    p(displayUnit="Pa") = 101325 + dp_nominal,
    use_T_in=true,
    nPorts=1,
    use_p_in=true,
    use_X_in=true,
    T=299.85) "Source"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Buildings.Fluid.HeatExchangers.DXCoils.AirSource.SingleSpeedHeating
    sinSpeDX(
    redeclare package Medium = Medium,
    dp_nominal=dp_nominal,
    datCoi=datCoi,
    T_start=datCoi.sta[1].nomVal.TEvaIn_nominal,
    from_dp=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Single speed DX coil"
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));

  parameter
    Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.HeatingCoil
    datCoi(sta={
        Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.Stage(
        spe=1800/60,
        nomVal=
          Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.NominalValues(
          activate_CooCoi=false,
          Q_flow_nominal=15000,
          COP_nominal=2.75,
          SHR_nominal=1,
          m_flow_nominal=0.782220983308365,
          TEvaIn_nominal=273.15 + 6,
          TConIn_nominal=273.15 + 21),
        perCur=
          Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Examples.PerformanceCurves.DXHeating_Curve_II())},
      nSta=1,
    defCur(
      defOpe=Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.DefrostOperation.resistive,
      QDefResCap=10500,
      QCraCap=200,
      PLFraFunPLR={1}))
              "Coil data"
    annotation (Placement(transformation(extent={{120,40},{140,60}})));

  Modelica.Blocks.Sources.TimeTable plr_onOff(table=[0,0; 3600,0; 3600,0; 7200,0;
        7200,0; 10800,0; 10800,0; 14400,0; 14400,0; 18000,0; 18000,0; 21600,0; 21600,
        0; 25200,0; 25200,1; 28800,1; 28800,1; 32400,1; 32400,1; 36000,1; 36000,
        1; 39600,1; 39600,1; 43200,1; 43200,1; 46800,1; 46800,1; 50400,1; 50400,
        1; 54000,1; 54000,1; 57600,1; 57600,1; 61200,1; 61200,0; 64800,0; 64800,
        0; 68400,0; 68400,0; 72000,0; 72000,0; 75600,0; 75600,0; 79200,0; 79200,
        0; 82800,0; 82800,0; 86400,0])
    "EnergyPlus PLR converted into on-off signal for this model"
    annotation (Placement(transformation(extent={{-140,100},{-120,120}})));
  Modelica.Blocks.Sources.TimeTable TEvaIn(table=[0,1.1; 3600,1.1; 3600,1.45;
        7200,1.45; 7200,2.633333333; 10800,2.633333333; 10800,3.65; 14400,3.65;
        14400,3.55; 18000,3.55; 18000,2.658333333; 21600,2.658333333; 21600,
        1.908333333; 25200,1.908333333; 25200,1.35; 28800,1.35; 28800,
        2.091666667; 32400,2.091666667; 32400,2.8; 36000,2.8; 36000,2.8; 39600,
        2.8; 39600,2.8; 43200,2.8; 43200,2.8; 46800,2.8; 46800,3.091666667;
        50400,3.091666667; 50400,2.658333333; 54000,2.658333333; 54000,
        1.908333333; 57600,1.908333333; 57600,1.058333333; 61200,1.058333333;
        61200,-0.1; 64800,-0.1; 64800,-2.175; 68400,-2.175; 68400,-4.291666667;
        72000,-4.291666667; 72000,-5.641666667; 75600,-5.641666667; 75600,-6.45;
        79200,-6.45; 79200,-6.991666667; 82800,-6.991666667; 82800,-8.483333333;
        86400,-8.483333333])           "Evaporator inlet temperature"
    annotation (Placement(transformation(extent={{-140,60},{-120,80}})));
  Modelica.Blocks.Sources.TimeTable TConIn(table=[0,7.136369805; 3600,
        7.136369805; 3600,6.799772375; 7200,6.799772375; 7200,6.600185851;
        10800,6.600185851; 10800,6.505553387; 14400,6.505553387; 14400,
        6.341530686; 18000,6.341530686; 18000,6.076479972; 21600,6.076479972;
        21600,5.762174559; 25200,5.762174559; 25200,15.96782811; 28800,
        15.96782811; 28800,18.67409277; 32400,18.67409277; 32400,18.94248504;
        36000,18.94248504; 36000,18.85030982; 39600,18.85030982; 39600,
        18.82851233; 43200,18.82851233; 43200,18.80523492; 46800,18.80523492;
        46800,18.81896489; 50400,18.81896489; 50400,18.71809233; 54000,
        18.71809233; 54000,18.57424703; 57600,18.57424703; 57600,18.42126277;
        61200,18.42126277; 61200,13.68399783; 64800,13.68399783; 64800,
        10.72916647; 68400,10.72916647; 68400,9.656951144; 72000,9.656951144;
        72000,8.797902105; 75600,8.797902105; 75600,7.975163685; 79200,
        7.975163685; 79200,7.216919975; 82800,7.216919975; 82800,6.434804657;
        86400,6.434804657])                    "Coil inlet temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-120,0}})));
  Modelica.Blocks.Sources.TimeTable XConIn(table=[0,0.003582422; 3600,
        0.003582422; 3600,0.003481312; 7200,0.003481312; 7200,0.003358903;
        10800,0.003358903; 10800,0.003165163; 14400,0.003165163; 14400,
        0.002999176; 18000,0.002999176; 18000,0.002903661; 21600,0.002903661;
        21600,0.002795683; 25200,0.002795683; 25200,0.002692848; 28800,
        0.002692848; 28800,0.002668362; 32400,0.002668362; 32400,0.002684606;
        36000,0.002684606; 36000,0.002711312; 39600,0.002711312; 39600,
        0.002739576; 43200,0.002739576; 43200,0.002741221; 46800,0.002741221;
        46800,0.00276825; 50400,0.00276825; 50400,0.00287037; 54000,0.00287037;
        54000,0.003063415; 57600,0.003063415; 57600,0.003157237; 61200,
        0.003157237; 61200,0.003163789; 64800,0.003163789; 64800,0.003016965;
        68400,0.003016965; 68400,0.0027215; 72000,0.0027215; 72000,0.002251071;
        75600,0.002251071; 75600,0.001852488; 79200,0.001852488; 79200,
        0.001581599; 82800,0.001581599; 82800,0.001407737; 86400,0.001407737])
    "Water fraction of moist air"
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));
  Modelica.Blocks.Math.RealToBoolean onOff
    annotation (Placement(transformation(extent={{-100,100},{-80,120}})));
  Modelica.Blocks.Routing.Multiplex2 mux "Converts in an array"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Buildings.Utilities.IO.BCVTB.From_degC TEvaIn_K "Converts degC to K"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Buildings.Utilities.IO.BCVTB.From_degC TConIn_K "Converts degC to K"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  Modelica.Blocks.Math.Mean TOutMea(f=1/3600)
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Buildings.Utilities.IO.BCVTB.To_degC TOutDegC
    annotation (Placement(transformation(extent={{120,80},{140,100}})));
  Modelica.Blocks.Sources.RealExpression TOut(y=sinSpeDX.vol.T)
    annotation (Placement(transformation(extent={{40,80},{60,100}})));
  Modelica.Blocks.Math.Mean XConOutMea(f=1/3600)
    annotation (Placement(transformation(extent={{80,120},{100,140}})));
  Modelica.Blocks.Sources.RealExpression XConOut(y=sum(sinSpeDX.vol.Xi))
    annotation (Placement(transformation(extent={{40,120},{60,140}})));
  Modelica.Blocks.Math.Mean Q_flowMea(f=1/3600) "Mean of cooling rate"
    annotation (Placement(transformation(extent={{0,80},{20,100}})));
  Modelica.Blocks.Math.Mean PMea(f=1/3600) "Mean of power"
    annotation (Placement(transformation(extent={{80,40},{100,60}})));
  Modelica.Blocks.Math.Add add(k1=-1)
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Modelica.Blocks.Sources.Constant XConInMoiAir(k=1.0) "Moist air fraction = 1"
    annotation (Placement(transformation(extent={{-140,-120},{-120,-100}})));
  Modelica.Blocks.Sources.TimeTable TOutEPlu(table=[0,7.136369805; 3600,
        7.136369805; 3600,6.799772375; 7200,6.799772375; 7200,6.600185851;
        10800,6.600185851; 10800,6.505553387; 14400,6.505553387; 14400,
        6.341530686; 18000,6.341530686; 18000,6.076479972; 21600,6.076479972;
        21600,5.762174559; 25200,5.762174559; 25200,34.04885601; 28800,
        34.04885601; 28800,37.21358399; 32400,37.21358399; 32400,37.65649868;
        36000,37.65649868; 36000,37.55585329; 39600,37.55585329; 39600,
        37.5313048; 43200,37.5313048; 43200,37.50607519; 46800,37.50607519;
        46800,37.58340034; 50400,37.58340034; 50400,37.37675573; 54000,
        37.37675573; 54000,37.05237219; 57600,37.05237219; 57600,36.70114791;
        61200,36.70114791; 61200,13.68399783; 64800,13.68399783; 64800,
        10.72916647; 68400,10.72916647; 68400,9.656951144; 72000,9.656951144;
        72000,8.797902105; 75600,8.797902105; 75600,7.975163685; 79200,
        7.975163685; 79200,7.216919975; 82800,7.216919975; 82800,6.434804657;
        86400,6.434804657])
    "EnergyPlus result: outlet temperature"
    annotation (Placement(transformation(extent={{-40,-140},{-20,-120}})));
  Modelica.Blocks.Sources.TimeTable Q_flowEPlu(table=[0,0; 3600,0; 3600,0; 7200,
        0; 7200,0; 10800,0; 10800,0; 14400,0; 14400,0; 18000,0; 18000,0; 21600,
        0; 21600,0; 25200,0; 25200,14282.6101; 28800,14282.6101; 28800,
        14644.10382; 32400,14644.10382; 32400,14782.39854; 36000,14782.39854;
        36000,14776.43429; 39600,14776.43429; 39600,14775.02981; 43200,
        14775.02981; 43200,14773.53231; 46800,14773.53231; 46800,14824.5099;
        50400,14824.5099; 50400,14743.71045; 54000,14743.71045; 54000,
        14606.24427; 57600,14606.24427; 57600,14452.0362; 61200,14452.0362;
        61200,0; 64800,0; 64800,0; 68400,0; 68400,0; 72000,0; 72000,0; 75600,0;
        75600,0; 79200,0; 79200,0; 82800,0; 82800,0; 86400,0])
                                             "EnergyPlus result: heat flow"
    annotation (Placement(transformation(extent={{40,-140},{60,-120}})));
  Modelica.Blocks.Sources.TimeTable XConOutEPlu(table=[0,0.003582422; 3600,
        0.003582422; 3600,0.003481312; 7200,0.003481312; 7200,0.003358903;
        10800,0.003358903; 10800,0.003165163; 14400,0.003165163; 14400,
        0.002999176; 18000,0.002999176; 18000,0.002903661; 21600,0.002903661;
        21600,0.002795683; 25200,0.002795683; 25200,0.002692848; 28800,
        0.002692848; 28800,0.002668362; 32400,0.002668362; 32400,0.002684606;
        36000,0.002684606; 36000,0.002711312; 39600,0.002711312; 39600,
        0.002739576; 43200,0.002739576; 43200,0.002741221; 46800,0.002741221;
        46800,0.00276825; 50400,0.00276825; 50400,0.00287037; 54000,0.00287037;
        54000,0.003063415; 57600,0.003063415; 57600,0.003157237; 61200,
        0.003157237; 61200,0.003163789; 64800,0.003163789; 64800,0.003016965;
        68400,0.003016965; 68400,0.0027215; 72000,0.0027215; 72000,0.002251071;
        75600,0.002251071; 75600,0.001852488; 79200,0.001852488; 79200,
        0.001581599; 82800,0.001581599; 82800,0.001407737; 86400,0.001407737])
    "EnergyPlus result: outlet water mass fraction"
    annotation (Placement(transformation(extent={{0,-140},{20,-120}})));
  Modelica.Blocks.Sources.TimeTable PEPlu(table=[0,0; 3600,0; 3600,0; 7200,0;
        7200,0; 10800,0; 10800,0; 14400,0; 14400,0; 18000,0; 18000,0; 21600,0;
        21600,0; 25200,0; 25200,5056.902679; 28800,5056.902679; 28800,
        5230.607002; 32400,5230.607002; 32400,5251.198845; 36000,5251.198845;
        36000,5236.881366; 39600,5236.881366; 39600,5233.502819; 43200,
        5233.502819; 43200,5229.897747; 46800,5229.897747; 46800,5224.477931;
        50400,5224.477931; 50400,5220.549702; 54000,5220.549702; 54000,
        5220.337707; 57600,5220.337707; 57600,5225.782154; 61200,5225.782154;
        61200,0; 64800,0; 64800,0; 68400,0; 68400,0; 72000,0; 72000,0; 75600,0;
        75600,0; 79200,0; 79200,0; 82800,0; 82800,0; 86400,0])
    "EnergyPlus result: electric power"
    annotation (Placement(transformation(extent={{-80,-140},{-60,-120}})));
  Modelica.Blocks.Sources.Pulse p(
    nperiod=1,
    offset=101325,
    amplitude=1141,
    width=100,
    period=36000,
    startTime=25200) "Pressure"
    annotation (Placement(transformation(extent={{-140,20},{-120,40}})));
  Modelica.Blocks.Sources.RealExpression XConInMod(y=XConIn.y/(1 +XConIn.y))
    "Modified XConIn"
    annotation (Placement(transformation(extent={{-140,-54},{-120,-34}})));
  Modelica.Blocks.Sources.RealExpression XConOutEPluMod(y=XConOutEPlu.y/(1 +
        XConOutEPlu.y))
    "Modified XConOut of energyPlus to comapre with the model results"
    annotation (Placement(transformation(extent={{0,-110},{20,-90}})));
equation
  connect(sou.ports[1], sinSpeDX.port_a)
                                        annotation (Line(
      points={{-20,-10},{-16,-10},{-16,10},{-10,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sinSpeDX.port_b, sin.ports[1])
                                        annotation (Line(
      points={{10,10},{16,10},{16,-10},{20,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(plr_onOff.y, onOff.u)         annotation (Line(
      points={{-119,110},{-102,110}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(onOff.y, sinSpeDX.on)         annotation (Line(
      points={{-79,110},{-60,110},{-60,18},{-11,18}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(mux.y, sou.X_in)          annotation (Line(
      points={{-59,-50},{-52,-50},{-52,-14},{-42,-14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TEvaIn.y, TEvaIn_K.Celsius) annotation (Line(
      points={{-119,70},{-116,70},{-116,69.6},{-102,69.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TEvaIn_K.Kelvin, sinSpeDX.TOut) annotation (Line(
      points={{-79,69.8},{-66.5,69.8},{-66.5,13},{-11,13}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TConIn.y,TConIn_K. Celsius)    annotation (Line(
      points={{-119,-10},{-112.1,-10},{-112.1,-10.4},{-102,-10.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TConIn_K.Kelvin, sou.T_in)    annotation (Line(
      points={{-79,-10.2},{-51.7,-10.2},{-51.7,-6},{-42,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TOut.y, TOutMea.u)
                           annotation (Line(
      points={{61,90},{78,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TOutMea.y, TOutDegC.Kelvin)
                                    annotation (Line(
      points={{101,90},{118,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(XConOut.y,XConOutMea. u)
                           annotation (Line(
      points={{61,130},{78,130}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(XConInMoiAir.y, add.u2)
                           annotation (Line(
      points={{-119,-110},{-112,-110},{-112,-96},{-102,-96}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y, mux.u2[1]) annotation (Line(
      points={{-79,-90},{-68,-90},{-68,-68},{-96,-68},{-96,-56},{-82,-56}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sinSpeDX.P, PMea.u) annotation (Line(
      points={{11,19},{14,19},{14,50},{78,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(p.y, sou.p_in) annotation (Line(
      points={{-119,30},{-74,30},{-74,-2},{-42,-2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(XConInMod.y, mux.u1[1]) annotation (Line(
      points={{-119,-44},{-82,-44}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(XConInMod.y, add.u1) annotation (Line(
      points={{-119,-44},{-110,-44},{-110,-84},{-102,-84}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sinSpeDX.QSen_flow, Q_flowMea.u) annotation (Line(points={{11,17},{20,
          17},{20,54},{-10,54},{-10,90},{-2,90}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-160,
            -140},{160,140}})),
             __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/DXCoils/AirSource/Validation/SingleSpeedHeatingEnergyPlus.mos"
        "Simulate and Plot"),
    experiment(Tolerance=1e-6, StopTime=86400),
    Documentation(info="<html>
<p>
This model validates the model
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.AirSource.SingleSpeed\">
Buildings.Fluid.HeatExchangers.DXCoils.AirSource.SingleSpeed</a>.
</p>
<p>
The difference in results of
<i>T<sub>Out</sub></i> and
<i>X<sub>Out</sub></i>
at the beginning and end of the simulation is because the mass flow rate is zero.
For zero mass flow rate, EnergyPlus assumes steady state condition,
whereas the Modelica model is a dynamic model and hence the properties at the outlet
are equal to the state variables of the model.
</p>
<p>
The EnergyPlus results were generated using the example file <code>DXCoilSystemAuto.idf</code>
from EnergyPlus 7.1,
with a nominal cooling capacity of <i>10500</i> Watts instead of using
autosizing. This allowed to have a part load ratio of one.
</p>
<p>
Note that EnergyPlus mass fractions (<code>X</code>) are in mass of water vapor per mass of dry air,
whereas Modelica uses the total mass as a reference. Hence, the EnergyPlus values
are corrected by dividing them by
<code>1+X</code>.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
December 22, 2014 by Michael Wetter:<br/>
Removed <code>Modelica.Fluid.System</code>
to address issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/311\">#311</a>.
</li>
<li>
September 4, 2012 by Michael Wetter:<br/>
Modified example to avoid having to access protected data.
</li>
<li>
August 20, 2012 by Kaustubh Phalak:<br/>
First implementation.
</li>
</ul>

</html>"));
end SingleSpeedHeatingEnergyPlus;
