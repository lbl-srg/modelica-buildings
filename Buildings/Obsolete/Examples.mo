within Buildings.Obsolete;
package Examples
  "Collection of models that illustrate model use and test models"
  extends Modelica.Icons.ExamplesPackage;

  package VAVReheat "Variable air volume flow system with terminal reheat and five thermal zones"
    extends Modelica.Icons.ExamplesPackage;

    model VAVBranch
      extends Modelica.Blocks.Icons.Block;
      replaceable package MediumA = Modelica.Media.Interfaces.PartialMedium
        "Medium model for air" annotation (choicesAllMatching=true);
      replaceable package MediumW = Modelica.Media.Interfaces.PartialMedium
        "Medium model for water" annotation (choicesAllMatching=true);

      parameter Boolean allowFlowReversal=true
        "= false to simplify equations, assuming, but not enforcing, no flow reversal";
      parameter Modelica.SIunits.MassFlowRate m_flow_nominal
        "Nominal air mass flow rate";
      parameter Real ratVFloHea(start=0.3, min=0, max=1, unit="1")
        "Maximum air flow rate ratio in heating mode";
      parameter Modelica.SIunits.Volume VRoo "Room volume";
      parameter Modelica.SIunits.Temperature THotWatInl_nominal(
        start=50 + 273.15,
        displayUnit="degC")
        "Reheat coil nominal inlet water temperature";
      parameter Modelica.SIunits.Temperature THotWatOut_nominal(
        start=THotWatInl_nominal-10,
        displayUnit="degC")
        "Reheat coil nominal outlet water temperature";
      parameter Modelica.SIunits.Temperature TAirInl_nominal(
        start=12 + 273.15,
        displayUnit="degC")
        "Inlet air nominal temperature";
      parameter Modelica.SIunits.HeatFlowRate QHea_flow_nominal=
        m_flow_nominal * ratVFloHea * cpAir * (32 + 273.15 - TAirInl_nominal)
        "Nominal heating heat flow rate";

      Buildings.Examples.VAVReheat.BaseClasses.VAVReheatBox vavRehBox(
        redeclare package MediumA = MediumA,
        redeclare package MediumW = MediumW,
        m_flow_nominal=m_flow_nominal,
        ratVFloHea=ratVFloHea,
        VRoo=VRoo,
        THotWatInl_nominal=THotWatInl_nominal,
        THotWatOut_nominal=THotWatOut_nominal,
        TAirInl_nominal=TAirInl_nominal) "Terminal Reheat Box"
        annotation (Placement(transformation(extent={{-20,-20},{20,20}})));
      Buildings.Fluid.Sources.Boundary_pT sinTer(
      redeclare package Medium = MediumW,
      p(displayUnit="Pa") = 3E5,
        nPorts=1)
                "Sink for terminal reheat box" annotation (Placement(transformation(
            extent={{10,10},{-10,-10}},
            rotation=-90,
            origin={-40,-80})));
      Buildings.Fluid.Sources.MassFlowSource_T souTer(
        redeclare package Medium = MediumW,
        use_m_flow_in=true,
        T=THotWatInl_nominal,
        nPorts=1) "Source for terminal reheat box"
        annotation (Placement(transformation(extent={{-10,10},{10,-10}}, origin={-58,0})));
      Buildings.Controls.OBC.CDL.Continuous.Gain gaiM_flow(
      final k=QHea_flow_nominal/cpWater/(THotWatInl_nominal - THotWatOut_nominal))
        "Gain for hot water mass flow rate" annotation (Placement(transformation(
            extent={{10,-10},{-10,10}},
            rotation=-90,
            origin={-80,-52})));

      Modelica.Blocks.Interfaces.RealInput yVAV "Signal for VAV damper"
        annotation (
          Placement(transformation(extent={{-140,40},{-100,80}}),
            iconTransformation(extent={{-140,40},{-100,80}})));
      Modelica.Blocks.Interfaces.RealInput yVal
        "Actuator position for reheat valve (0: closed, 1: open)" annotation (
          Placement(transformation(extent={{-20,-20},{20,20}},origin={-120,-80}),
            iconTransformation(extent={{-20,-20},{20,20}},origin={-120,-80})));

      Modelica.Blocks.Interfaces.RealOutput y_actual "Actual VAV damper position"
        annotation (Placement(transformation(extent={{100,-10},{120,10}}),
            iconTransformation(extent={{100,-10},{120,10}})));
      Modelica.Fluid.Interfaces.FluidPort_a port_b(redeclare package Medium =
            MediumA)
        "Fluid connector b (positive design flow direction is from port_a1 to port_b1)"
        annotation (Placement(transformation(extent={{-10,90},{10,110}}),
            iconTransformation(extent={{-10,90},{10,110}})));
      Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
            MediumA)
        "Fluid connector a1 (positive design flow direction is from port_a1 to port_b1)"
        annotation (Placement(transformation(extent={{-10,-110},{10,-90}}),
            iconTransformation(extent={{-10,-110},{10,-90}})));
    protected
      constant Modelica.SIunits.SpecificHeatCapacity cpAir = 1004
        "Air specific heat capacity";
      constant Modelica.SIunits.SpecificHeatCapacity cpWater = 4180
        "Water specific heat capacity";
    equation
      connect(yVAV, vavRehBox.yVAV) annotation (Line(points={{-120,60},{-70,60},{-70,
              12},{-24,12}}, color={0,0,127}));
      connect(vavRehBox.y_actual, y_actual)
        annotation (Line(points={{22,0},{110,0}}, color={0,0,127}));
      connect(port_b, vavRehBox.port_bAir)
        annotation (Line(points={{0,100},{0,20}}, color={0,127,255}));
      connect(vavRehBox.port_aAir, port_a)
        annotation (Line(points={{0,-20},{0,-100}}, color={0,127,255}));
      connect(sinTer.ports[1], vavRehBox.port_bHotWat) annotation (Line(points={{-40,
              -70},{-44,-70},{-44,-12},{-20,-12}}, color={0,127,255}));
      connect(gaiM_flow.y, souTer.m_flow_in)
        annotation (Line(points={{-80,-40},{-80,-8},{-70,-8}},
                                                           color={0,0,127}));
      connect(souTer.ports[1], vavRehBox.port_aHotWat)
        annotation (Line(points={{-48,0},{-20,0}}, color={0,127,255}));
      connect(yVal, gaiM_flow.u) annotation (Line(points={{-120,-80},{-80,-80},{-80,
              -64}}, color={0,0,127}));
      annotation (Documentation(revisions="<html>
<ul>
<li>
February 11, 2021, by Baptiste Ravache:<br/>
Moved to Obsolete. Refactored coil sizing and nominal temperature values.
This class is now a wrapper around the prefered class 
<code>Buildings.Examples.VAVReheat.BaseClasses.VAVReheatBox</code>.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2059\">#2024</a>.
</li>
</ul>
</html>", info="<html>
<p>
Model for a VAV supply branch. 
The terminal VAV box has a pressure independent damper and a water reheat coil. 
The pressure independent damper model includes an idealized flow rate controller 
and requires a discharge air flow rate set-point (normalized to the nominal value) 
as a control signal.
</p>
</html>"));
    end VAVBranch;
    annotation (Documentation(info="<html>
<p>
This package contains variable air volume flow models
for office buildings.
</p>
<h4>Note</h4>
<p>
The models
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus.Examples.SmallOffice.ASHRAE2006Winter\">
Buildings.ThermalZones.EnergyPlus.Examples.SmallOffice.ASHRAE2006Winter</a>
and
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus.Examples.SmallOffice.Guideline36Winter\">
Buildings.ThermalZones.EnergyPlus.Examples.SmallOffice.Guideline36Winter</a>
appear to be quite similar to
<a href=\"modelica://Buildings.Examples.VAVReheat.ASHRAE2006\">
Buildings.Examples.VAVReheat.ASHRAE2006</a>
and
<a href=\"modelica://Buildings.Examples.VAVReheat.Guideline36\">
Buildings.Examples.VAVReheat.Guideline36</a>,
respectively, because they all have the same HVAC system, control sequences,
and all have five thermal zones.
However, the models in
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus.Examples.SmallOffice\">
Buildings.ThermalZones.EnergyPlus.Examples.SmallOffice</a>
are from the
<i>DOE Commercial Reference Building,
Small Office, new construction, ASHRAE 90.1-2004,
Version 1.3_5.0</i>,
whereas the models in
<a href=\"modelica://Buildings.Examples.VAVReheat\">
Buildings.Examples.VAVReheat</a>
are from the
<i>DOE Commercial Building Benchmark,
Medium Office, new construction, ASHRAE 90.1-2004,
version 1.2_4.0</i>.
Therefore, the dimensions of the thermal zones in
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus.Examples.SmallOffice\">
Buildings.ThermalZones.EnergyPlus.Examples.SmallOffice</a>
are considerably smaller than in
<a href=\"modelica://Buildings.Examples.VAVReheat\">
Buildings.Examples.VAVReheat</a>.
As the sizing is scaled with the volumes of the thermal zones, the model <i>structure</i>
is the same, but the design capacities are different, as is the energy consumption.
</p>
</html>"));
  end VAVReheat;

  package Validation
    extends Modelica.Icons.ExamplesPackage;
    model VAVBranch "Validation for the VAVBranch class"
      extends Modelica.Icons.Example;

      package MediumA = Buildings.Media.Air "Medium model for air";
      package MediumW = Buildings.Media.Water "Medium model for water";

      Buildings.Obsolete.Examples.VAVReheat.VAVBranch vavBra(
        redeclare package MediumA = MediumA,
        redeclare package MediumW = MediumW,
        m_flow_nominal=45,
        allowFlowReversal=true,
        ratVFloHea=1,
        VRoo=275,
        THotWatInl_nominal=355.35,
        THotWatOut_nominal=313.15,
        TAirInl_nominal=289.85,
        QHea_flow_nominal=45*1006*(50 - 16.7))
        annotation (Placement(transformation(extent={{20,-20},{60,20}})));

      Buildings.Fluid.Sources.Boundary_ph sinAir(
        redeclare package Medium = MediumA,
        p(displayUnit="Pa") = 1E5,
        nPorts=1) "Sink for terminal reheat box outlet air" annotation (Placement(
            transformation(
            extent={{10,10},{-10,-10}},
            rotation=90,
            origin={40,70})));
      Modelica.Blocks.Sources.Ramp TSupAir(
        height=5,
        duration(displayUnit="h") = 3600,
        offset=285,
        startTime(displayUnit="h") = 3600) "Supply Air Temperature"
        annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
      Modelica.Blocks.Sources.Ramp heaSig(
        height=1,
        duration(displayUnit="h") = 3600,
        offset=0,
        startTime(displayUnit="h") = 10800) "Signal to reheat coil valve"
        annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
      Modelica.Blocks.Sources.Ramp damSig(
        height=0.4,
        duration(displayUnit="h") = 3600,
        offset=0.2,
        startTime(displayUnit="h") = 18000) "Signal to VAV Box Damper"
        annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
      Buildings.Fluid.Sources.Boundary_pT bou(
        redeclare package Medium = MediumA,
        p(displayUnit="Pa") = 1E5 + 1500,
        use_T_in=true,
        nPorts=1)
        annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
    equation
      connect(vavBra.port_b, sinAir.ports[1])
        annotation (Line(points={{40,20},{40,60},{40,60}}, color={0,127,255}));
      connect(heaSig.y, vavBra.yVal) annotation (Line(points={{-39,-10},{-20,-10},{-20,
              -16},{16,-16}}, color={0,0,127}));
      connect(damSig.y, vavBra.yVAV) annotation (Line(points={{-39,50},{-20,50},{-20,
              12},{16,12}}, color={0,0,127}));
      connect(bou.ports[1], vavBra.port_a)
        annotation (Line(points={{10,-60},{40,-60},{40,-20}}, color={0,127,255}));
      connect(TSupAir.y, bou.T_in) annotation (Line(points={{-39,-70},{-24,-70},{-24,
              -56},{-12,-56}},      color={0,0,127}));
      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{120,100}})),                                  Diagram(
            coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
                120,100}})),
        experiment(StopTime=25200, __Dymola_Algorithm="Dassl"),
        Documentation(info="<html>
This model validates the previous VAVBranch model, using similar inputs to those that
were hardcoded in the model in previous versions.
</html>", revisions="<html>
</html>"));
    end VAVBranch;
  end Validation;
annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains a tutorial with step by step instructions
for how to build system models.
This package also contains examples of system models that are
composed of models from a variety of packages of the
<code>Buildings</code> library. The examples illustrate
the scope of the library. Smaller examples that typically only
use models from a few packages can be found in the individual packages.
For example, see
<a href=\"modelica://Buildings.Airflow.Multizone.Examples\">
Buildings.Airflow.Multizone.Examples</a> for examples of
multizone airflow and contaminant transport models, or
<a href=\"modelica://Buildings.Fluid.HeatExchangers.Examples\">
Buildings.Fluid.HeatExchangers.Examples</a> for
examples of heat exchanger models.
</p>
</html>"));
end Examples;
