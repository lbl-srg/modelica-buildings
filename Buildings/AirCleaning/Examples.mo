within Buildings.AirCleaning;
package Examples

  model PACExample
    replaceable package Medium = Buildings.Media.Air(extraPropertiesNames={"CO2", "SARS-CoV-2"}) "Medium model for air";
    parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=1.2*vol.V/3600
      "Design mass flow rate";
    Buildings.Fluid.MixingVolumes.MixingVolumeMoistAir
                                             vol(
      redeclare package Medium = Medium,
      final energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
      final massDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
      final V=500,
      final C_start={0,0},
      final mSenFac=1,
      final m_flow_nominal=m_flow_nominal,
      final prescribedHeatFlowRate=true,
      final nPorts=1,
      m_flow_small=1E-4*abs(m_flow_nominal),
      allowFlowReversal=true,
      final use_C_flow=true)        "Room air volume"
      annotation (Placement(transformation(extent={{40,-10},{60,10}})));
    Modelica.Blocks.Sources.Constant conZero(k=0)
      annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
    Buildings.AirCleaning.PAC pAC(
      redeclare package Medium = Medium,
      eff={0,0.99},
      flow_PAC=100*1.2/3600,
      kpow=50)
      annotation (Placement(transformation(extent={{-30,-60},{-10,-40}})));
    Modelica.Blocks.Sources.RealExpression speConc2(y=vol.C[2])
      "SARS-CoV-2 concentration"
      annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));
    Buildings.Fluid.Sources.MassFlowSource_T sup(
      use_C_in=false,
      C={0.1,0.1},
      use_m_flow_in=false,
      redeclare package Medium = Medium,
      m_flow=m_flow_nominal,
      nPorts=1) "Supply airflow"
      annotation (Placement(transformation(extent={{-68,-10},{-48,10}})));
    Modelica.Blocks.Sources.BooleanConstant conPACEna "True when PAC is on"
      annotation (Placement(transformation(extent={{-90,-72},{-70,-52}})));
    Modelica.Blocks.Sources.RealExpression speConc1(y=vol.C[1])
      "CO2 concentration"
      annotation (Placement(transformation(extent={{-90,-30},{-70,-10}})));
  equation
    connect(pAC.diss, vol.heatPort) annotation (Line(points={{-9.6,-58},{-2,-58},{
            -2,2},{34,2},{34,0},{40,0}},
                  color={191,0,0}));
    connect(sup.ports[1], vol.ports[1]) annotation (Line(points={{-48,0},{6,0},{6,
            -16},{50,-16},{50,-10}},   color={0,127,255}));
    connect(conPACEna.y, pAC.uPACEna) annotation (Line(points={{-69,-62},{-46,-62},
            {-46,-52},{-32,-52}}, color={255,0,255}));
    connect(pAC.yC_flow[1], vol.C_flow[1]) annotation (Line(points={{-9,-46},{0,-46},
            {0,-6},{38,-6}},                     color={0,0,127}));
    connect(pAC.yC_flow[2], vol.C_flow[2]) annotation (Line(points={{-9,-46},{8,-46},
            {8,-6},{38,-6}},                     color={0,0,127}));
    connect(speConc1.y, pAC.C[1]) annotation (Line(points={{-69,-20},{-46,-20},{-46,
            -46},{-32,-46}},                         color={0,0,127}));
    connect(speConc2.y, pAC.C[2]) annotation (Line(points={{-69,-40},{-46,-40},{-46,
            -46},{-32,-46}}, color={0,0,127}));
    connect(conZero.y, vol.mWat_flow)
      annotation (Line(points={{-19,50},{38,50},{38,8}}, color={0,0,127}));
    annotation (
      Icon(coordinateSystem(preserveAspectRatio=false)),
      Diagram(coordinateSystem(preserveAspectRatio=false)),
      Documentation(info="<html>
<p>This example simulates <a href=\"modelica://Buildings.AirCleaning.PAC\">AirCleaning.PAC</a> for a scenario with CO<sub>2. </sub>and SARS-CoV-2 as trace species. Airflow with a constant rate and concentration of trace species is supplied to a mixing volume. A PAC is connected to the mixing volume to simulate removal of trace species from the volume, where the PAC cannot remove the gaseous CO<sub>2</sub> but filters SARS-CoV-2 with an efficiency of 99&percnt;.</p>
</html>"),
      experiment(StopTime=3600, __Dymola_Algorithm="Dassl"));
  end PACExample;

  model DuctGUVExample
    replaceable package Medium = Buildings.Media.Air(extraPropertiesNames={"CO2", "SARS-CoV-2"}) "Medium model for air";
    parameter Modelica.Units.SI.MassFlowRate m_flow_nominal = 6.71
      "Design mass flow rate";
    Buildings.AirCleaning.DuctGUV ducGUV(
      dp_nominal=0,
      kGUV={10e6,0.69},
      kpow=200,
      m_flow_nominal=m_flow_nominal,
      redeclare package Medium = Medium)
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
    Buildings.Fluid.Sources.MassFlowSource_T flo(
      use_C_in=false,
      C={1,1},
      use_m_flow_in=true,
      redeclare package Medium = Medium,
      nPorts=1)
      annotation (Placement(transformation(extent={{-48,-10},{-28,10}})));
    Modelica.Blocks.Sources.Ramp ramFlo(
      height=0.75*m_flow_nominal,
      duration=3600,
      offset=0.25*m_flow_nominal,
      startTime=120)
      annotation (Placement(transformation(extent={{-90,20},{-70,40}})));
    Modelica.Blocks.Sources.BooleanConstant onSig
      annotation (Placement(transformation(extent={{-66,-50},{-46,-30}})));
    Buildings.Fluid.MixingVolumes.MixingVolume vol(
      m_flow_nominal=m_flow_nominal,
      V=500,                                       nPorts=1, redeclare package
        Medium =                                                                        Medium)
      annotation (Placement(transformation(extent={{40,10},{60,30}})));

  equation
    connect(flo.ports[1], ducGUV.port_a)
      annotation (Line(points={{-28,0},{-10,0}}, color={0,127,255}));
    connect(onSig.y, ducGUV.u) annotation (Line(points={{-45,-40},{-20,-40},{-20,
            -8},{-12,-8}}, color={255,0,255}));
    connect(ramFlo.y, flo.m_flow_in) annotation (Line(points={{-69,30},{-58,30},{-58,
            8},{-50,8}}, color={0,0,127}));
    connect(ducGUV.port_b, vol.ports[1]) annotation (Line(points={{10,0},{50,0},
            {50,10}},                    color={0,127,255}));
    annotation (
      Icon(coordinateSystem(preserveAspectRatio=false)),
      Diagram(coordinateSystem(preserveAspectRatio=false)),
      experiment(StopTime=3840, __Dymola_Algorithm="Dassl"));
  end DuctGUVExample;

  model GUVExample
    replaceable package Medium = Buildings.Media.Air(extraPropertiesNames={"CO2", "SARS-CoV-2"}) "Medium model for air";
    parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=1.2*vol.V/3600
      "Design mass flow rate";
    Buildings.Fluid.MixingVolumes.MixingVolumeMoistAir
                                             vol(
      redeclare package Medium = Medium,
      final energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
      final massDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
      final V=500,
      final C_start={0,0},
      final mSenFac=1,
      final m_flow_nominal=m_flow_nominal,
      final prescribedHeatFlowRate=true,
      final nPorts=1,
      m_flow_small=1E-4*abs(m_flow_nominal),
      allowFlowReversal=true,
      final use_C_flow=true)        "Room air volume"
      annotation (Placement(transformation(extent={{38,-10},{58,10}})));
    Modelica.Blocks.Sources.Constant const(k=0)
      annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
    Modelica.Blocks.Sources.RealExpression speConc2(y=vol.C[2])
      "SARS-CoV-2 concentration"
      annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));
    Buildings.Fluid.Sources.MassFlowSource_T sup(
      use_C_in=false,
      C={0.1,0.1},
      use_m_flow_in=false,
      redeclare package Medium = Medium,
      m_flow=m_flow_nominal,
      nPorts=1)
      annotation (Placement(transformation(extent={{-68,-10},{-48,10}})));
    Modelica.Blocks.Sources.BooleanConstant booleanConstant
      annotation (Placement(transformation(extent={{-90,-72},{-70,-52}})));
    Modelica.Blocks.Sources.RealExpression speConc1(y=vol.C[1])
      "CO2 concentration"
      annotation (Placement(transformation(extent={{-90,-32},{-70,-12}})));
    Buildings.AirCleaning.RoomGUV gUV(
      redeclare package Medium = Medium,
      frad=0.2,
      Eavg=0.5,
      krad={0,0.28},
      kpow=60,
      V=vol.V)
      annotation (Placement(transformation(extent={{-30,-56},{-10,-36}})));
  equation
    connect(const.y, vol.mWat_flow) annotation (Line(points={{-19,50},{28,50},{28,
            8},{36,8}},  color={0,0,127}));
    connect(sup.ports[1], vol.ports[1]) annotation (Line(points={{-48,0},{-4,0},{-4,
            -12},{34,-12},{34,-14},{48,-14},{48,-10}},
                                       color={0,127,255}));
    connect(booleanConstant.y, gUV.u) annotation (Line(points={{-69,-62},{-38,-62},
            {-38,-48},{-32,-48}}, color={255,0,255}));
    connect(speConc1.y, gUV.C[1]) annotation (Line(points={{-69,-22},{-46,-22},{-46,
            -42},{-32,-42}},                         color={0,0,127}));
    connect(speConc2.y, gUV.C[2]) annotation (Line(points={{-69,-40},{-46,-40},{-46,
            -42},{-32,-42}}, color={0,0,127}));
    connect(gUV.yC_flow[1], vol.C_flow[1]) annotation (Line(points={{-9,-42},{0,-42},
            {0,-6},{36,-6}},     color={0,0,127}));
    connect(gUV.yC_flow[2], vol.C_flow[2]) annotation (Line(points={{-9,-42},{8,-42},
            {8,-6},{36,-6}},     color={0,0,127}));
    connect(gUV.diss, vol.heatPort) annotation (Line(points={{-9.6,-54},{4,-54},{4,
            0},{38,0}},    color={191,0,0}));
    annotation (
      Icon(coordinateSystem(preserveAspectRatio=false)),
      Diagram(coordinateSystem(preserveAspectRatio=false)),
      experiment(StopTime=3600, __Dymola_Algorithm="Dassl"),
      Documentation(info="<html>
<p>This example simulates <a href=\"modelica://Buildings.AirCleaning.PAC\">AirCleaning.GUV</a> for a scenario with CO<sub>2. </sub>and SARS-CoV-2 as trace species. Airflow with a constant rate and concentration of trace species is supplied to a mixing volume. A GUV device is connected to the mixing volume to simulate removal of trace species from the volume, where the GUV does not inactivate CO<sub>2</sub> but inactivates SARS-CoV-2.</p>
</html>"));
  end GUVExample;
end Examples;
