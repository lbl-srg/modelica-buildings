within Buildings.Fluid.FixedResistances.Validation.PlugFlowPipes;
model PlugFlowULg "Validation against data from Université de Liège"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water;

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=1
    "Nominal mass flow rate, used for regularization near zero flow";
  parameter Modelica.Units.SI.Temperature T_start_in=pipeDataULg.T_start_in +
      273.15 "Initial temperature at pipe inlet";
  parameter Modelica.Units.SI.Temperature T_start_out=pipeDataULg.T_start_out
       + 273.15 "Initial temperature at pipe outlet";
  parameter Modelica.Units.SI.SpecificHeatCapacity cp_default=
      Medium.specificHeatCapacityCp(state=sta_default)
    "Heat capacity of medium";
  parameter Medium.ThermodynamicState sta_default=Medium.setState_pTX(
      T=Medium.T_default,
      p=Medium.p_default,
      X=Medium.X_default) "Default medium state";

  Fluid.Sources.MassFlowSource_T WaterCityNetwork(
    redeclare package Medium = Medium,
    m_flow=1.245,
    use_m_flow_in=true,
    nPorts=1) "Mass flow source"
              annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={70,0})));
  Fluid.HeatExchangers.Heater_T Boiler(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dp_nominal=0) "Boiler with adjustable outlet temperature"
                  annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={30,0})));
  Fluid.Sources.Boundary_pT Sewer1(
    redeclare package Medium = Medium,
    nPorts=1) "Mass flow sink"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-210,0})));
  Fluid.Sensors.TemperatureTwoPort senTem_out(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    tau=0,
    T_start=T_start_out) "Temperature sensor"
    annotation (Placement(transformation(extent={{-160,-10},{-180,10}})));
  Fluid.Sensors.TemperatureTwoPort senTem_in(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    tau=0,
    T_start=T_start_in) "Temperature sensor"
    annotation (Placement(transformation(extent={{0,-10},{-20,10}})));
  Modelica.Blocks.Sources.CombiTimeTable DataReader(
    tableOnFile=true,
    tableName="dat",
    fileName=pipeDataULg.filNam,
    columns=2:pipeDataULg.nCol,
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint)
    "Measurement data"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));

  Modelica.Blocks.Math.UnitConversions.From_degC Tout
    "Ambient temperature in degrees"
    annotation (Placement(transformation(extent={{40,-110},{60,-90}})));
  Buildings.HeatTransfer.Sources.FixedTemperature TBou(T=295.15)
    "Fixed boundary condition"
                         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-90,32})));
  Modelica.Blocks.Math.UnitConversions.From_degC Tin
    "Input temperature into pipe"
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));

  replaceable Data.PipeDataULg151202 pipeDataULg constrainedby
    Data.BaseClasses.PipeDataULg
    "Measurement dataset from ULg (use Change Class... to choose from different experiments)"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  Modelica.Blocks.Math.Gain gain(k=1)
    "Gain to test variations of mass flow rate within measurement uncertainty "
    annotation (Placement(transformation(extent={{52,-50},{72,-30}})));
  PlugFlowPipe pipe(
    redeclare package Medium = Medium,
    dh=0.05248,
    length=39,
    dIns(displayUnit="mm") = 0.013,
    kIns=0.04,
    m_flow_nominal=m_flow_nominal,
    thickness=3.9e-3,
    T_start_out=T_start_out,
    T_start_in=T_start_in,
    R=((1/(2*pipe.kIns)*log((0.0603/2 + pipe.dIns)/(0.0603/2))) + 1/(5*(0.0603
         + 2*pipe.dIns)))/Modelica.Constants.pi,
    initDelay=true,
    m_flow_start=pipeDataULg.m_flowIni,
    cPip=500,
    rhoPip=8000) "Pipe"
    annotation (Placement(transformation(extent={{-80,-10},{-100,10}})));
  Fluid.Sensors.EnthalpyFlowRate senEntOut(redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal) "Outlet enthalpy sensor"
    annotation (Placement(transformation(extent={{-120,-10},{-140,10}})));
  Modelica.Blocks.Math.Add heatLossSim(k1=-1)
    "Difference between inflowing and outflowing enthalpy streams"
    annotation (Placement(transformation(extent={{80,50},{100,70}})));
  Modelica.Blocks.Continuous.Integrator eneLosInt "Integrate model error"
    annotation (Placement(transformation(extent={{230,50},{250,70}})));
  Fluid.Sensors.EnthalpyFlowRate senEntIn(redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal) "Inlet enthalpy sensor"
    annotation (Placement(transformation(extent={{-42,-10},{-62,10}})));
  Modelica.Blocks.Math.Add delT(k2=-1)
    "Temperature difference between in- and outlet"
    annotation (Placement(transformation(extent={{120,-100},{140,-80}})));
  Modelica.Blocks.Math.Product heaLosMea
    "Heat loss from measurement (mflow*cp*DeltaT)"
    annotation (Placement(transformation(extent={{160,-80},{180,-60}})));
  Modelica.Blocks.Math.Gain gain3(k=cp_default) "Specific heat of water"
    annotation (Placement(transformation(extent={{120,-50},{140,-30}})));
  Modelica.Blocks.Math.Feedback heaLosDiff
    "Difference between simulated and measurement enthalpy flow difference"
    annotation (Placement(transformation(extent={{190,50},{210,70}})));
  Modelica.Blocks.Sources.Constant Tamb(k=273 + 18)
    "Ambient temperature in Kelvin";
equation
  connect(DataReader.y[3], Tout.u) annotation (Line(
      points={{21,-70},{32,-70},{32,-100},{38,-100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(DataReader.y[5], Tin.u)
    annotation (Line(points={{21,-70},{38,-70}},            color={0,0,127}));
  connect(DataReader.y[1], gain.u) annotation (Line(points={{21,-70},{32,-70},{32,
          -40},{50,-40}}, color={0,0,127}));
  connect(senTem_in.port_a, Boiler.port_b)
    annotation (Line(points={{0,0},{12,0},{12,1.33227e-15},{20,1.33227e-15}},
                                                    color={0,127,255}));
  connect(Boiler.port_a, WaterCityNetwork.ports[1])
    annotation (Line(points={{40,-1.33227e-15},{40,0},{60,0}},
                                                    color={0,127,255}));
  connect(gain.y, WaterCityNetwork.m_flow_in) annotation (Line(points={{73,-40},
          {104,-40},{104,8},{82,8}},
                                   color={0,0,127}));
  connect(Tin.y, Boiler.TSet) annotation (Line(points={{61,-70},{94,-70},{94,28},
          {52,28},{52,8},{42,8}},          color={0,0,127}));
  connect(Sewer1.ports[1], senTem_out.port_b)
    annotation (Line(points={{-200,-1.11022e-15},{-188,-1.11022e-15},{-188,0},{-180,
          0}},                                  color={0,127,255}));
  connect(senTem_out.port_a, senEntOut.port_b)
    annotation (Line(points={{-160,0},{-140,0}},       color={0,127,255}));
  connect(senEntOut.port_a, pipe.port_b)
    annotation (Line(points={{-120,0},{-100,0}},       color={0,127,255}));
  connect(pipe.port_a, senEntIn.port_b)
    annotation (Line(points={{-80,0},{-62,0}}, color={0,127,255}));
  connect(senTem_in.port_b, senEntIn.port_a)
    annotation (Line(points={{-20,0},{-42,0}},
                                            color={0,127,255}));
  connect(TBou.port, pipe.heatPort)
    annotation (Line(points={{-90,22},{-90,10}}, color={191,0,0}));
  connect(gain.y, gain3.u)
    annotation (Line(points={{73,-40},{118,-40}},color={0,0,127}));
  connect(heaLosMea.y, heaLosDiff.u2)
    annotation (Line(points={{181,-70},{200,-70},{200,52}}, color={0,0,127}));
  connect(heatLossSim.y, heaLosDiff.u1)
    annotation (Line(points={{101,60},{192,60}},  color={0,0,127}));
  connect(heaLosDiff.y, eneLosInt.u)
    annotation (Line(points={{209,60},{228,60}},          color={0,0,127}));
  connect(delT.u1, Tin.y) annotation (Line(points={{118,-84},{104,-84},{104,-70},
          {61,-70}}, color={0,0,127}));
  connect(Tout.y, delT.u2) annotation (Line(points={{61,-100},{88,-100},{88,-96},
          {118,-96}}, color={0,0,127}));
  connect(heaLosMea.u1, gain3.y) annotation (Line(points={{158,-64},{148,-64},{148,
          -40},{141,-40}}, color={0,0,127}));
  connect(heaLosMea.u2, delT.y) annotation (Line(points={{158,-76},{150,-76},{150,
          -90},{141,-90}}, color={0,0,127}));
  connect(heatLossSim.u2, senEntIn.H_flow)
    annotation (Line(points={{78,54},{-52,54},{-52,11}}, color={0,0,127}));
  connect(heatLossSim.u1, senEntOut.H_flow)
    annotation (Line(points={{78,66},{-130,66},{-130,11}}, color={0,0,127}));
  annotation (
    Documentation(info="<html>
<p>
The example contains
experimental data from a real district heating network.
</p>
<p>
This model compares the results with the original Modelica Standard Library pipes.
</p>
<p>The pipes' temperatures are not initialized. Therefore, results of
outflow temperature before approximately the first 10000 seconds should not be
considered.
</p>
<h4>Test bench schematic</h4>
<p><img alt=\"Schematic of test rig at ULg\"
src=\"modelica://Buildings/Resources/Images/Fluid/FixedResistances/Validation/PlugFlowPipes/ULgTestBench.png\"/> </p>
<h4>Calibration</h4>
<p>
There are some uncertainties about the heat loss coefficient between pipe and
surrounding air as well as regarding the heat conductivity of the insulation
material.
With the <a href=\"modelica://Buildings.Fluid.FixedResistances.Validation.PlugFlowPipes.Data.PipeDataULg150801\">
given data</a>, the length specific thermal resistance is <code>R = 2.164
</code>((m K)/W), calculated as follows:
</p>
<p align=\"center\"style=\"font-style:italic;\">
R=((1/(2*pipe.kIns)*log((0.0603+2*pipe.dIns)/(0.0603)))+1/(5*(0.0603+2*pipe.dIns)))/Modelica.Constants.pi</p>
<p align=\"center\"style=\"font-style:italic;\">
U = 1/R = 0.462 W/(m K)</p>
</html>", revisions="<html>
<ul>
<li>
March 7, 2020, by Michael Wetter:<br/>
Replaced measured data from specification in Modelica file to external table,
as this reduces the computing time.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1289\"> #1289</a>.
</li>
<li>
November 24, 2016 by Bram van der Heijde:<br/>Add pipe thickness for wall
capacity calculation and expand documentation section.</li>
<li>April 2, 2016 by Bram van der Heijde:<br/>Change thermal conductivity and
put boundary condition in K.
</li>
<li>Januar 26, 2016 by Carles Ribas:<br/>First implementation.
</li>
</ul>
</html>"),
    experiment(StopTime=875, Tolerance=1e-006),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FixedResistances/Validation/PlugFlowPipes/PlugFlowULg.mos"
        "Simulate and plot"),
    Diagram(coordinateSystem(extent={{-260,-120},{260,120}})));
end PlugFlowULg;
