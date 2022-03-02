within Buildings.Experimental.DHC.Loads.Steam;
package BaseClasses

  model SteamTwoWayValveSelfActing
    "Partial model for a steam two way valve using a Kv characteristic"

    extends Buildings.Fluid.Interfaces.PartialTwoPortInterface;

    parameter Modelica.Units.SI.Pressure pb_nominal(displayUnit="Pa", min=100)
      "Nominal outlet pressure" annotation (Dialog(group="Nominal condition"));

    Buildings.Fluid.Movers.BaseClasses.IdealSource idealSource(
      redeclare package Medium = Medium,
      allowFlowReversal=allowFlowReversal,
      dp_start=pb_nominal,
      m_flow_start=m_flow_nominal,
      m_flow_small=m_flow_small,
      show_T=show_T,
      control_m_flow=false,
      control_dp=true) "idealSource controlled for dp"
                       annotation (Placement(transformation(extent={{0,-10},{20,10}})));
    Modelica.Blocks.Sources.RealExpression pbSet(y=pb_nominal)
      "Downstream pressure setpoint"
      annotation (Placement(transformation(extent={{-68,46},{-48,66}})));
    Modelica.Blocks.Math.Add add(k1=-1)
                                 annotation (Placement(transformation(extent={{-20,40},
              {0,60}})));
    Buildings.Fluid.Sensors.Pressure pUp(redeclare package Medium = Medium)
      "Pressure sensor"
      annotation (Placement(transformation(extent={{-70,20},{-50,40}})));
  equation
    connect(port_a, idealSource.port_a)
      annotation (Line(points={{-100,0},{0,0}},   color={0,127,255}));
    connect(idealSource.port_b, port_b) annotation (Line(points={{20,0},{100,0}},color={0,127,255}));
    connect(pbSet.y, add.u1) annotation (Line(points={{-47,56},{-22,56}}, color={0,0,127}));
    connect(add.y, idealSource.dp_in)
      annotation (Line(points={{1,50},{16,50},{16,8}},   color={0,0,127}));
    connect(idealSource.port_a, pUp.port)
      annotation (Line(points={{0,0},{-60,0},{-60,20}},   color={0,127,255}));
    connect(pUp.p, add.u2)
      annotation (Line(points={{-49,30},{-28,30},{-28,44},{-22,44}}, color={0,0,127}));
    annotation (
  Documentation(info="<html>
<p>
Steam reducing pressure valves are used for precise control of the downstream pressure of 
steam and automatically adjust the amount of valve opening to allow the pressure to remain 
unchanged even when the flow rate fluctuates by pistons, springs, or diaphragms.

This valve model implementation which doesnot depend on valve parmeters and quadratic relationships of m_flow and dp,
that make the model computationally intensive. The model is simplified by fixing 
the downstream pressure to the user specified value. 
</p>
<h4>Implementation</h4>
<p>
This pressure regulator isimplemented using afictitious pipe model<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.IdealSource\">
Buildings.Fluid.Movers.BaseClasses.IdealSource</a> that is used as a base class for a pressure source or to prescribe a mass flow rate. 


</p>
</html>",
  revisions="<html>
<ul>
<li>
January 2, 2022 by Saranya Anbarasu:<br/>
First implementation.
</li>
</ul>
</html>"),   Icon(graphics={               Rectangle(
        extent={{-52,40},{68,-40}},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid,
        pattern=LinePattern.None),
          Rectangle(
            extent={{-100,40},{100,-40}},
            lineColor={0,0,0},
            fillPattern=FillPattern.HorizontalCylinder,
            fillColor={192,192,192}),
          Rectangle(
            extent={{-100,22},{100,-24}},
            lineColor={0,0,0},
            fillPattern=FillPattern.HorizontalCylinder,
            fillColor={0,127,255}),        Rectangle(
        extent={{-60,40},{60,-40}},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid,
        pattern=LinePattern.None),
          Ellipse(
            extent={{-26,80},{26,40}},
            lineColor={0,0,0},
            fillColor={160,160,160},
            fillPattern=FillPattern.Solid),Rectangle(
        extent={{-32,60},{34,12}},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid,
        pattern=LinePattern.None),
      Polygon(
        points={{0,0},{-76,60},{-76,-60},{0,0}},
        lineColor={0,0,0},
        fillColor=DynamicSelect({0,0,0}, y*{255,255,255}),
        fillPattern=FillPattern.Solid),
      Polygon(
        points={{0,0},{76,60},{76,-60},{0,0}},
        lineColor={0,0,0},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
          Line(points={{-26,60},{26,60}}, color={0,0,0}),
          Line(points={{0,0},{0,60}}, color={0,0,0}),
          Line(points={{0,80},{0,100}}, color={0,0,0}),
          Line(points={{0,100},{52,100}}, color={0,0,0}),
          Line(points={{52,100},{0,0}}, color={0,0,0})}));
  end SteamTwoWayValveSelfActing;

  package Examples
    model SteamTwoWayValveSelfActing
      "Example model to exhibit the performance of self-acting steam valve"
      extends Modelica.Icons.Example;

      package MediumSteam = Buildings.Media.Steam;

      parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=1
        "Nominal mass flow rate";
      parameter Modelica.Units.SI.AbsolutePressure pIn=900000 "Inlet pressure";

      parameter Modelica.Units.SI.Temperature TSat=
          MediumSteam.saturationTemperature(pIn) "Saturation temperature";

      Buildings.Experimental.DHC.Loads.Steam.BaseClasses.SteamTwoWayValveSelfActing
                                                          prv(
        redeclare package Medium = MediumSteam,
        m_flow_nominal=m_flow_nominal,
        show_T=true,
        pb_nominal=300000) "Self acting valve"
        annotation (Placement(transformation(extent={{0,-10},{20,10}})));
      Buildings.Fluid.Sources.Boundary_pT sou(
        redeclare package Medium = MediumSteam,
        use_p_in=true,
        p(displayUnit="Pa"),
        T(displayUnit="K") = MediumSteam.saturationTemperature(sou.p),
        nPorts=1) annotation (Placement(transformation(extent={{-60,-10},{-40,
                10}})));
      Buildings.Fluid.Sensors.SpecificEnthalpyTwoPort speEntIn(redeclare
          package Medium =
            MediumSteam,
          m_flow_nominal=m_flow_nominal)
                            annotation (Placement(transformation(extent={{-30,-10},
                {-10,10}})));
      Buildings.Fluid.Sensors.SpecificEnthalpyTwoPort speEntOu(redeclare
          package Medium =
            MediumSteam,
          m_flow_nominal=m_flow_nominal)
                            annotation (Placement(transformation(extent={{30,-10},
                {50,10}})));
      Modelica.Blocks.Noise.UniformNoise pInSig(
        samplePeriod(displayUnit="s") = 1,
        y_min=900000 + 50000,
        y_max=900000 - 50000)
                           "Noisy signal for inlet pressure"
        annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
      Fluid.Sources.MassFlowSource_T sin(
        redeclare package Medium = MediumSteam,
        use_m_flow_in=true,
        nPorts=1)
        annotation (Placement(transformation(extent={{80,-10},{60,10}})));
      Modelica.Blocks.Sources.Ramp m_flow_sig(
        height=-1,
        duration=5,
        startTime=5) "Mass flow rate signal"
        annotation (Placement(transformation(extent={{-50,40},{-30,60}})));
      inner Modelica.Blocks.Noise.GlobalSeed globalSeed
        annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
    equation
      connect(sou.ports[1], speEntIn.port_a)
        annotation (Line(points={{-40,0},{-30,0}}, color={0,127,255}));
      connect(speEntIn.port_b, prv.port_a) annotation (Line(points={{-10,0},{0,
              0}},                                                                  color={0,127,255}));
      connect(prv.port_b, speEntOu.port_a) annotation (Line(points={{20,0},{30,
              0}},                                                                  color={0,127,255}));
      connect(pInSig.y, sou.p_in)
        annotation (Line(points={{-79,50},{-70,50},{-70,8},{-62,8}}, color={0,0,127}));
      connect(sin.ports[1], speEntOu.port_b)
        annotation (Line(points={{60,0},{50,0}}, color={0,127,255}));
      connect(m_flow_sig.y, sin.m_flow_in) annotation (Line(points={{-29,50},{
              90,50},{90,8},{82,8}}, color={0,0,127}));
      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    __Dymola_Commands(file=
        "modelica://DES/Resources/Scripts/Dymola/Heating/Loads/Valves/Examples/SteamTwoWayValveSelfActing.mos"
        "Simulate and plot"),
      experiment(StopTime=1000,Tolerance=1e-06),
        Documentation(info="<html>
<p>
Example model for the self-acting two way steam pressure regulating valve model.
</p>
</html>"));
    end SteamTwoWayValveSelfActing;

    model prvWithHex
      "Model to compare the performance of PRV and Ideal source"
      extends Modelica.Icons.Example;

      //package MediumSteam = DES.Media.Steam;
      package MediumWat = Buildings.Media.Water;

      parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=1
        "Nominal mass flow rate";
      parameter Modelica.Units.SI.AbsolutePressure pIn=900000 "Inlet pressure";

      parameter Modelica.Units.SI.Temperature TSat=
          MediumSteam.saturationTemperature(pIn) "Saturation temperature";

      Buildings.Fluid.Sources.Boundary_pT sou(
        redeclare package Medium = MediumSteam,
        use_p_in=false,
        p(displayUnit="Pa") = 900000,
        T(displayUnit="K") = MediumSteam.saturationTemperature(sou.p),
        nPorts=1) annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
      Buildings.Fluid.Sources.Boundary_pT sin(
        redeclare package Medium = MediumWat,
        p(displayUnit="Pa"),
        T(displayUnit="K"),
        nPorts=1) annotation (Placement(transformation(extent={{238,-10},{218,10}})));
      Buildings.Fluid.Sensors.SpecificEnthalpyTwoPort speEntIn(redeclare
          package
          Medium =
            MediumSteam,
          m_flow_nominal=m_flow_nominal)
                            annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
      Buildings.Fluid.Sensors.SpecificEnthalpyTwoPort speEntOu(redeclare
          package
          Medium =
            MediumSteam,
          m_flow_nominal=m_flow_nominal)
                            annotation (Placement(transformation(extent={{40,-10},{60,10}})));
      DES.Heating.EnergyTransferStations.BaseClasses.MixingVolumeCondensation mixingVolumeCondensation1(
        p_start=mixingVolumeCondensation1.pSat,
        T_start=TSat,
        pSat=300000,
        m_flow_nominal=1,
        V=20) annotation (Placement(transformation(extent={{100,-10},{120,10}})));
      Buildings.Fluid.Movers.FlowControlled_m_flow pumCNR(
        redeclare package Medium = MediumWat,
        m_flow_nominal=m_flow_nominal,
        addPowerToMedium=false,
        nominalValuesDefineDefaultPressureCurve=true)
        "Condensate return pump"
        annotation (Placement(transformation(extent={{180,-10},{200,10}})));
      Modelica.Blocks.Sources.Constant mFlo(k=1) "Nominal mass flow rate setpoint"
        annotation (Placement(transformation(extent={{238,40},{218,60}})));
      DES.Heating.EnergyTransferStations.BaseClasses.SteamTrap steTra(redeclare
          package Medium = MediumWat, final m_flow_nominal=m_flow_nominal)
        "Steam trap"
        annotation (Placement(transformation(extent={{140,-10},{160,10}})));
      Buildings.Experimental.DHC.Loads.Steam.BaseClasses.SteamTwoWayValveSelfActing
        steamTwoWayValveSelfActingIdeal(
        redeclare package Medium = MediumSteam,
        m_flow_nominal=m_flow_nominal,
        show_T=true,
        pb_nominal=300000) "Self acting valve"
        annotation (Placement(transformation(extent={{0,-10},{20,10}})));
    equation
      connect(sou.ports[1], speEntIn.port_a)
        annotation (Line(points={{-60,0},{-40,0}}, color={0,127,255}));
      connect(speEntOu.port_b, mixingVolumeCondensation1.port_a)
        annotation (Line(points={{60,0},{100,0}}, color={0,127,255}));
      connect(pumCNR.port_b, sin.ports[1])
        annotation (Line(points={{200,0},{218,0}}, color={0,127,255}));
      connect(mFlo.y, pumCNR.m_flow_in) annotation (Line(
          points={{217,50},{190,50},{190,12}},
          color={0,0,127},
          pattern=LinePattern.Dash));
      connect(mixingVolumeCondensation1.port_b, steTra.port_a)
        annotation (Line(points={{120,0},{140,0}}, color={0,127,255}));
      connect(steTra.port_b, pumCNR.port_a)
        annotation (Line(points={{160,0},{180,0}}, color={0,127,255}));
      connect(speEntIn.port_b, steamTwoWayValveSelfActingIdeal.port_a)
        annotation (Line(points={{-20,0},{0,0}}, color={0,127,255}));
      connect(steamTwoWayValveSelfActingIdeal.port_b, speEntOu.port_a)
        annotation (Line(points={{20,0},{40,0}}, color={0,127,255}));
      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false,
              extent={{-100,-140},{260,80}})),
    __Dymola_Commands(file=
        "modelica://DES/Resources/Scripts/Dymola/Heating/Loads/Valves/Examples/SteamTwoWayValveSelfActing.mos"
        "Simulate and plot"),
      experiment(StopTime=1000,Tolerance=1e-06),
        Documentation(info="<html>
<p>
Example model for the self-acting two way steam pressure regulating valve model.
</p>
</html>"));
    end prvWithHex;
  end Examples;
end BaseClasses;
