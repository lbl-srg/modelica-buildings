within Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Validation;
model SingleSpeedHeatingPLREnergyPlusDefrost_OnDemandReverseCycle
  "Validation model for single speed heating DX coil with defrost operation"
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
  Buildings.Fluid.HeatExchangers.DXCoils.AirSource.SingleSpeedHeating
    sinSpeDX(
    redeclare package Medium = Medium,
    dp_nominal=dp_nominal,
    datCoi=datCoi,
    T_start=datCoi.sta[1].nomVal.TEvaIn_nominal,
    from_dp=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    defCur=defCur,
    defOpe=Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.DefrostOperation.reverseCycle,
    defTri=Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.DefrostTriggers.onDemand,
    tDefRun=0.166667)
    "Single speed DX coil"
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));

  Buildings.Utilities.IO.BCVTB.From_degC TEvaIn_K "Converts degC to K"
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));
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
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
  Modelica.Blocks.Sources.RealExpression XConOutEPluMod(y=XConOutEPlu.y/(1 +
        XConOutEPlu.y))
    "Modified XConOut of energyPlus to comapre with the model results"
    annotation (Placement(transformation(extent={{0,-110},{20,-90}})));
  parameter
    Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.CoolingCoil
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
      nSta=1) "Coil data"
    annotation (Placement(transformation(extent={{80,40},{100,60}})));
  UnitDelay PEPlu(samplePeriod=3600)
    annotation (Placement(transformation(extent={{-68,-140},{-48,-120}})));
  UnitDelay Q_flowEPlu(samplePeriod=3600)
    annotation (Placement(transformation(extent={{100,-140},{120,-120}})));
  UnitDelay TOutEPlu(samplePeriod=3600, y_start=29.34948133)
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));
  UnitDelay XConOutEPlu(samplePeriod=1)
    annotation (Placement(transformation(extent={{30,-140},{50,-120}})));

  // The UnitDelay is reimplemented to avoid in Dymola 2016 the translation warning
  //   The initial conditions for variables of type Boolean are not fully specified.
  //   Dymola has selected default initial conditions.
  //   Assuming fixed default start value for the discrete non-states:
  //     PEPlu.firstTrigger(start = false)
  //     ...
  Data.Generic.BaseClasses.Defrost defCur(
    defOpe=Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.DefrostOperation.reverseCycle,
    QDefResCap=10500,
    QCraCap=200,
    defEIRFunT={0.297145,0.0430933,-0.000748766,0.00597727,0.000482112,-0.000956448},
    PLFraFunPLR={1})
    annotation (Placement(transformation(extent={{80,-6},{100,14}})));

  Buildings.Utilities.Psychrometrics.ToTotalAir toTotAir
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  Buildings.Utilities.Psychrometrics.ToTotalAir toTotAir1
    annotation (Placement(transformation(extent={{0,-140},{20,-120}})));
  UnitDelay PDefEPlu(samplePeriod=1)
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  UnitDelay PCraEPlu(samplePeriod=3600)
    annotation (Placement(transformation(extent={{100,-90},{120,-70}})));
  Modelica.Blocks.Sources.CombiTimeTable datRea(
    tableOnFile=true,
    fileName=ModelicaServices.ExternalReferences.loadResource("./Buildings/Resources/Data/Fluid/HeatExchangers/DXCoils/AirSource/Validation/SingleSpeedHeatingPLREnergyPlusDefrost_OnDemandReverseCycle/DXCoilSystemAuto.dat"),
    columns=2:18,
    tableName="EnergyPlus",
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments)
    "Reader for \"IndirectAbsorptionChiller.idf\" EnergyPlus example results"
      annotation (Placement(transformation(extent={{-152,110},{-132,130}})));

  BaseClasses.PLRToPulse pLRToPulse(timePeriod=3600)
    annotation (Placement(transformation(extent={{-80,110},{-60,130}})));
  Sources.MassFlowSource_T boundary(
    redeclare package Medium = Medium,
    use_Xi_in=true,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1) annotation (Placement(transformation(extent={{-48,-20},{-28,0}})));
  Buildings.Utilities.Psychrometrics.ToTotalAir toTotAir2
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
protected
  block UnitDelay
    extends Modelica.Blocks.Discrete.UnitDelay(
      firstTrigger(start=false, fixed=true));
  end UnitDelay;
equation
  connect(sinSpeDX.port_b, sin.ports[1])
                                        annotation (Line(
      points={{10,10},{16,10},{16,-10},{20,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TEvaIn_K.Kelvin, sinSpeDX.TOut) annotation (Line(
      points={{-79,79.8},{-66.5,79.8},{-66.5,13},{-11,13}},
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
  connect(sinSpeDX.QSen_flow, Q_flowMea.u) annotation (Line(points={{11,17},{20,
          17},{20,54},{-10,54},{-10,90},{-2,90}}, color={0,0,127}));
  connect(toTotAir.XiTotalAir, sinSpeDX.XOut) annotation (Line(points={{-79,50},
          {-20,50},{-20,1},{-11,1}}, color={0,0,127}));
  connect(toTotAir1.XiTotalAir, XConOutEPlu.u)
    annotation (Line(points={{21,-130},{28,-130}}, color={0,0,127}));
  connect(sinSpeDX.P, PMea.u) annotation (Line(points={{11,19},{25.5,19},{25.5,20},
          {38,20}}, color={0,0,127}));
  connect(datRea.y[14], pLRToPulse.uPLR)
    annotation (Line(points={{-131,120},{-82,120}}, color={0,0,127}));
  connect(pLRToPulse.y, sinSpeDX.on) annotation (Line(points={{-58,120},{-26,120},
          {-26,18},{-11,18}}, color={255,0,255}));
  connect(datRea.y[1], TEvaIn_K.Celsius) annotation (Line(points={{-131,120},{-108,
          120},{-108,79.6},{-102,79.6}}, color={0,0,127}));
  connect(datRea.y[9], toTotAir.XiDry) annotation (Line(points={{-131,120},{-108,
          120},{-108,50},{-101,50}}, color={0,0,127}));
  connect(datRea.y[17], boundary.m_flow_in) annotation (Line(points={{-131,120},
          {-108,120},{-108,16},{-50,16},{-50,-2}}, color={0,0,127}));
  connect(TConIn_K.Kelvin, boundary.T_in) annotation (Line(points={{-79,-10.2},{
          -60,-10.2},{-60,-6},{-50,-6}}, color={0,0,127}));
  connect(toTotAir2.XiTotalAir, boundary.Xi_in[1]) annotation (Line(points={{-79,
          -50},{-60,-50},{-60,-14},{-50,-14}}, color={0,0,127}));
  connect(datRea.y[5], TConIn_K.Celsius) annotation (Line(points={{-131,120},{-108,
          120},{-108,-10.4},{-102,-10.4}}, color={0,0,127}));
  connect(datRea.y[6], toTotAir2.XiDry) annotation (Line(points={{-131,120},{-108,
          120},{-108,-50},{-101,-50}}, color={0,0,127}));
  connect(boundary.ports[1], sinSpeDX.port_a) annotation (Line(points={{-28,-10},
          {-18,-10},{-18,10},{-10,10}}, color={0,127,255}));
  connect(datRea.y[7], TOutEPlu.u) annotation (Line(points={{-131,120},{-108,120},
          {-108,-30},{-10,-30},{-10,-60},{-2,-60}}, color={0,0,127}));
  connect(datRea.y[8], toTotAir1.XiDry) annotation (Line(points={{-131,120},{-108,
          120},{-108,-30},{-10,-30},{-10,-130},{-1,-130}}, color={0,0,127}));
  connect(datRea.y[3], PEPlu.u) annotation (Line(points={{-131,120},{-108,120},{
          -108,-30},{-10,-30},{-10,-108},{-74,-108},{-74,-130},{-70,-130}},
        color={0,0,127}));
  connect(datRea.y[2], Q_flowEPlu.u) annotation (Line(points={{-131,120},{-108,120},
          {-108,-30},{-10,-30},{-10,-108},{90,-108},{90,-130},{98,-130}}, color=
         {0,0,127}));
  connect(datRea.y[15], PDefEPlu.u) annotation (Line(points={{-131,120},{-108,120},
          {-108,-30},{-10,-30},{-10,-40},{98,-40}}, color={0,0,127}));
  connect(datRea.y[16], PCraEPlu.u) annotation (Line(points={{-131,120},{-108,120},
          {-108,-80},{98,-80}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-160,-140},
            {160,140}})),
             __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/DXCoils/AirSource/Validation/SingleSpeedHeatingPLREnergyPlusDefrost_OnDemandReverseCycle.mos"
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
from EnergyPlus 7.1.
<p>
The EnergyPlus results were generated using the example file
<code>DXCoilSystemAuto.idf</code> from EnergyPlus 7.1.
On the summer design day, the PLR is below 1.
A similar effect has been achieved in this example by turning on the coil only for the period
during which it run in EnergyPlus.
This results in on-off cycle and fluctuating results.
To compare the results, the Modelica outputs are averaged over <i>3600</i> seconds,
and the EnergyPlus outputs are used with a zero order delay to avoid the time shift in results.
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
September 24, 2015 by Michael Wetter:<br/>
Implemented <code>UnitDelay</code> to avoid a translation warning
because <code>UnitDelay.firstTrigger</code> does not set the <code>fixed</code>
attribute in MSL 3.2.1.
</li>
<li>
June 9, 2015, by Michael Wetter:<br/>
Corrected wrong link to run script.
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
end SingleSpeedHeatingPLREnergyPlusDefrost_OnDemandReverseCycle;
