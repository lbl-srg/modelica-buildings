within Buildings.Fluid;
package SolarCollectors
extends Modelica.Icons.VariantsPackage;

  model Concentrating "Model of a concentrating solar collector"
  extends Buildings.Fluid.SolarCollectors.BaseClasses.PartialSolarCollector(
        perPar=per);
      parameter Buildings.Fluid.SolarCollectors.Data.Concentrating.Generic
                                                                 per
      "Performance data"  annotation (choicesAllMatching=true);

    parameter Modelica.SIunits.Temperature TMean_nominal
      "Inlet temperature at nominal condition"
      annotation(Dialog(group="Nominal condition"));
    BaseClasses.EN12975SolarGain solHeaGaiNom(
      A_c=per.A,
      nSeg=nSeg,
      y_intercept=per.y_intercept,
      B0=per.B0,
      B1=per.B1,
      shaCoe=shaCoe,
      til=til,
      iamDiff=per.IAMDiff)
      annotation (Placement(transformation(extent={{0,60},{20,80}})));
    BaseClasses.EN12975HeatLoss heaLos(
      A_c=per.A,
      nSeg=nSeg,
      y_intercept=per.y_intercept,
      C1=per.C1,
      C2=per.C2,
      I_nominal=I_nominal,
      TMean_nominal=TMean_nominal,
      TEnv_nominal=TEnv_nominal,
      Cp=Cp,
      m_flow_nominal=rho*per.VperA_flow_nominal*per.A)
             annotation (Placement(transformation(extent={{0,20},{20,40}})));
    Modelica.Blocks.Math.Add add
      annotation (Placement(transformation(extent={{-42,74},{-34,82}})));
  equation
    connect(temSen.T, heaLos.TFlu) annotation (Line(
        points={{-4,-16},{-16,-16},{-16,24},{-2,24}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(weaBus.TDryBul, heaLos.TEnv) annotation (Line(
        points={{-100,78},{-88,78},{-88,36},{-2,36}},
        color={255,204,51},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
    connect(HDirTil.inc, solHeaGaiNom.incAng) annotation (Line(
        points={{-59,52},{-50,52},{-50,66},{-2,66}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(HDirTil.H, solHeaGaiNom.HDirTil) annotation (Line(
        points={{-59,56},{-54,56},{-54,72},{-2,72}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(add.y, solHeaGaiNom.HSkyDifTil) annotation (Line(
        points={{-33.6,78},{-2,78}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(HDifTilIso.HGroDifTil, add.u2) annotation (Line(
        points={{-59,76},{-54,76},{-54,75.6},{-42.8,75.6}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(HDifTilIso.HSkyDifTil, add.u1) annotation (Line(
        points={{-59,88},{-54,88},{-54,80.4},{-42.8,80.4}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(solHeaGaiNom.QSol_flow, heaGai.Q_flow) annotation (Line(
        points={{21,70},{38,70}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(heaLos.QLos, QLos.Q_flow) annotation (Line(
        points={{21,30},{38,30}},
        color={0,0,127},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}),
                        graphics),
        defaultComponentName="solCol",
       Documentation(info="<html>
 <h4>Overview</h4>
 <p>
 This component models a concentrating solar thermal collector. The concentrating model uses ratings data based on EN12975 and by default references the <a href=\"modelica://Buildings.Fluid.SolarCollectors.Data.Concentrating\"> 
 Buildingds.Fluid.SolarCollectors.Data.Concentrating</a> data library.
 </p>
 <h4>Notice</h4>
 <p>
 1. As metioned in the reference, the SRCC incident angle modifier equation coefficients are only valid for incident angles of 60 degrees or less. 
 Because these curves can be valid yet behave poorly for angles greater than 60 degrees, the model cuts off collectors' gains of both direct and diffuse solar radiation for incident angles greater than 60 degrees. 
 <br>
 2. By default, the esitimated heat capacity of the collector without fluid is calculated based on the dry mass and the specific heat capacity of copper.
 </p>
 <h4>References</h4>
 <p>
 <a href=\"http://www.energyplus.gov\">EnergyPlus 7.0.0 Engineering Reference</a>, October 13, 2011.
 <br>
 J.A. Duffie and W.A. Beckman 2006, Solar Engineering of Thermal Processes (3rd Edition), John Wiley & Sons, Inc.  
 </p>
 </html>",   revisions="<html>
 <ul>
 <li>
 January 4, 2013, by Peter Grant:<br>
 First implementation.
 </li>
 </ul>
 </html>"));
  end Concentrating;

  model FlatPlate "Model of a flat plate solar thermal collector"
    extends Buildings.Fluid.SolarCollectors.BaseClasses.PartialSolarCollector(
        perPar=per);
    parameter Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate.Generic
      per
      annotation(choicesAllMatching=true);
    parameter Modelica.SIunits.Temperature TIn_nominal
      "Inlet temperature at nominal condition"
      annotation(Dialog(group="Nominal condition"));
    Buildings.Fluid.SolarCollectors.BaseClasses.ASHRAESolarGain solHeaGai(
      B0=per.B0,
      B1=per.B1,
      shaCoe=shaCoe,
      til=til,
      nSeg=nSeg,
      y_intercept=per.y_intercept,
      A_c=per.A)
               annotation (Placement(transformation(extent={{0,60},{20,80}})));
  public
    Buildings.Fluid.SolarCollectors.BaseClasses.ASHRAEHeatLoss heaLos(
      Cp=Cp,
      nSeg=nSeg,
      I_nominal=I_nominal,
      TEnv_nominal=TEnv_nominal,
      A_c=per.A,
      TIn_nominal=TIn_nominal,
      slope=per.slope,
      y_intercept=per.y_intercept,
      m_flow_nominal=rho*per.VperA_flow_nominal*per.A)
          annotation (Placement(transformation(extent={{0,20},{20,40}})));
  equation
    connect(temSen.T, heaLos.TFlu) annotation (Line(
        points={{-4,-16},{-16,-16},{-16,24},{-2,24}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(weaBus.TDryBul, heaLos.TEnv) annotation (Line(
        points={{-100,78},{-88,78},{-88,36},{-2,36}},
        color={255,204,51},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
    connect(HDirTil.inc, solHeaGai.incAng) annotation (Line(
        points={{-59,52},{-32,52},{-32,66},{-2,66}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(HDirTil.H, solHeaGai.HDirTil) annotation (Line(
        points={{-59,56},{-40,56},{-40,72},{-2,72}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(HDifTilIso.HSkyDifTil, solHeaGai.HSkyDifTil) annotation (Line(
        points={{-59,88},{-18,88},{-18,78},{-2,78}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(HDifTilIso.HGroDifTil, solHeaGai.HGroDifTil) annotation (Line(
        points={{-59,76},{-32,76},{-32,74.8},{-2,74.8}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(heaLos.QLos, QLos.Q_flow) annotation (Line(
        points={{21,30},{38,30}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(solHeaGai.QSol_flow, heaGai.Q_flow) annotation (Line(
        points={{21,70},{38,70}},
        color={0,0,127},
        smooth=Smooth.None));
    annotation (
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
              100,100}}),
              graphics),
      Icon(graphics={
          Rectangle(
            extent={{-86,100},{88,-100}},
            lineColor={215,215,215},
            fillColor={215,215,215},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-10,80},{10,-100}},
            lineColor={215,215,215},
            fillColor={135,135,135},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{30,80},{50,-100}},
            lineColor={215,215,215},
            fillColor={135,135,135},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-50,80},{-28,-100}},
            lineColor={215,215,215},
            fillColor={135,135,135},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-60,100},{60,80}},
            lineColor={215,215,215},
            fillColor={135,135,135},
            fillPattern=FillPattern.Solid),
          Ellipse(
            extent={{-24,28},{28,-24}},
            lineColor={255,0,0},
            fillColor={255,0,0},
            fillPattern=FillPattern.Solid),
          Line(
            points={{-48,2},{-28,2}},
            color={255,0,0},
            smooth=Smooth.None,
            thickness=1),
          Line(
            points={{34,2},{54,2}},
            color={255,0,0},
            smooth=Smooth.None,
            thickness=1),
          Line(
            points={{-8,-8},{6,6}},
            color={255,0,0},
            smooth=Smooth.None,
            thickness=1,
            origin={30,34},
            rotation=180),
          Line(
            points={{-34,-38},{-18,-22}},
            color={255,0,0},
            smooth=Smooth.None,
            thickness=1),
          Line(
            points={{-8,-8},{6,6}},
            color={255,0,0},
            smooth=Smooth.None,
            thickness=1,
            origin={32,-28},
            rotation=90),
          Line(
            points={{-6,-6},{8,8}},
            color={255,0,0},
            smooth=Smooth.None,
            thickness=1,
            origin={-22,32},
            rotation=90),
          Line(
            points={{-10,0},{10,0}},
            color={255,0,0},
            smooth=Smooth.None,
            thickness=1,
            origin={4,-38},
            rotation=90),
          Line(
            points={{-10,0},{10,0}},
            color={255,0,0},
            smooth=Smooth.None,
            thickness=1,
            origin={2,42},
            rotation=90)}),
      defaultComponentName="solCol",
      Documentation(info="<html>
<h4>Overview</h4>
<p>
This component models the flat plate solar thermal collector. By default this model uses ASHRAE 93 ratings data and references the <a href=\"modelica://Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate\">
Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate</a> data library.
</p>
<h4>Notice</h4>
<p>
1. As metioned in the reference, the SRCC incident angle modifier equation coefficients are only valid for incident angles of 60 degrees or less. 
Because these curves can be valid yet behave poorly for angles greater than 60 degrees the model cuts off collectors' gains of both direct and diffuse solar radiation for incident angles greater than 60 degrees. 
<br>
2. By default, the esitimated hea capacity of the collector without fluid is calculated based on the dry mass and the specific heat capacity of copper.
</p>
<h4>References</h4>
<p>
<a href=\"http://www.energyplus.gov\">EnergyPlus 7.0.0 Engineering Reference</a>, October 13, 2011.
<br>
J.A. Duffie and W.A. Beckman 2006, Solar Engineering of Thermal Processes (3rd Edition), John Wiley & Sons, Inc.  
</p>
</html>",   revisions="<html>
<ul>
<li>
January 4, 2013, by Peter Grant:<br>
First implementation.
</li>
</ul>
</html>"));
  end FlatPlate;

  model Tubular
    extends Buildings.Fluid.SolarCollectors.BaseClasses.PartialSolarCollector(
        perPar=per);
      parameter Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate.Generic
      per "Performance data"
                          annotation (choicesAllMatching=true);
    parameter Modelica.SIunits.Temperature TIn_nominal
      "Inlet temperature at nominal condition"
      annotation(Dialog(group="Nominal condition"));
    BaseClasses.ASHRAESolarGain solHeaGaiNom(
      nSeg=nSeg,
      y_intercept=per.y_intercept,
      B0=per.B0,
      B1=per.B1,
      shaCoe=0.1,
      A_c=per.A,
      til=0.69813170079773)
      annotation (Placement(transformation(extent={{-10,60},{10,80}})));
    BaseClasses.ASHRAEHeatLoss heaLos(
      A_c=per.A,
      nSeg=nSeg,
      y_intercept=per.y_intercept,
      slope=per.slope,
      I_nominal=I_nominal,
      TIn_nominal=TIn_nominal,
      TEnv_nominal=TEnv_nominal,
      Cp=Cp,
      m_flow_nominal=rho*per.VperA_flow_nominal*per.A)
      annotation (Placement(transformation(extent={{-12,20},{8,40}})));
  equation
    connect(temSen.T, heaLos.TFlu) annotation (Line(
        points={{-4,-16},{-20,-16},{-20,24},{-14,24}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(weaBus.TDryBul, heaLos.TEnv) annotation (Line(
        points={{-100,78},{-88,78},{-88,36},{-14,36}},
        color={255,204,51},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
    connect(HDirTil.inc, solHeaGaiNom.incAng) annotation (Line(
        points={{-59,52},{-50,52},{-50,66},{-12,66}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(HDirTil.H, solHeaGaiNom.HDirTil) annotation (Line(
        points={{-59,56},{-52,56},{-52,72},{-12,72}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(HDifTilIso.HGroDifTil, solHeaGaiNom.HGroDifTil) annotation (Line(
        points={{-59,76},{-52,76},{-52,74.8},{-12,74.8}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(HDifTilIso.HSkyDifTil, solHeaGaiNom.HSkyDifTil) annotation (Line(
        points={{-59,88},{-52,88},{-52,78},{-12,78}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(heaLos.QLos, QLos.Q_flow) annotation (Line(
        points={{9,30},{38,30}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(solHeaGaiNom.QSol_flow, heaGai.Q_flow) annotation (Line(
        points={{11,70},{24,70},{24,70},{38,70}},
        color={0,0,127},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}),
                        graphics),
         defaultComponentName="solCol",
       Documentation(info="<html>
 <h4>Overview</h4>
 <p>
 This component models the tubular solar thermal collector. By default this model uses ASHRAE 93 ratings data and references the <a href=\"modelica://Buildings.Fluid.SolarCollectors.Data.Tubular\">
  Buildings.Fluid.SolarCollectors.Data.Tubular</a> data library.
 </p>
 <h4>Notice</h4>
 <p>
 1. As metioned in the reference, the SRCC incident angle modifier equation coefficients are only valid for incident angles of 60 degrees or less. 
 Because these curves can be valid yet behave poorly for angles greater than 60 degrees, the model cuts off collectors' gains of both direct and diffuse solar radiation for incident angles greater than 60 degrees. 
 <br>
 2. By default, the esitimated heat capacity of the collector without fluid is calculated based on the dry mass and the specific heat capacity of copper.
 </p>
 <h4>References</h4>
 <p>
 <a href=\"http://www.energyplus.gov\">EnergyPlus 7.0.0 Engineering Reference</a>, October 13, 2011.
 <br>
 J.A. Duffie and W.A. Beckman 2006, Solar Engineering of Thermal Processes (3rd Edition), John Wiley & Sons, Inc.  
 </p>
 </html>",   revisions="<html>
 <ul>
 <li>
 January 4, 2013, by Peter Grant:<br>
 First implementation.
 </li>
 </ul>
 </html>"));
  end Tubular;

  package Controls
    model SolarPumpController
      "Controller which activates a circulation pump when solar radiation is above a critical level"
      import Buildings;
      extends Modelica.Blocks.Interfaces.BlockIcon;
      parameter Real conDel "Width of the smoothHeaviside function";
      Modelica.Blocks.Interfaces.RealInput TIn(
      final unit = "K") "Water temperature entering the collector"
        annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
    parameter Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate.Generic         per
        "Performance data"
        annotation (choicesAllMatching=true, Placement(transformation(extent={{60,60},{80,80}})));
    public
      Modelica.Blocks.Interfaces.RealOutput conSig
        "On/off control signal from the pump"
        annotation (Placement(transformation(extent={{100,-18},{136,18}})));
      BoundaryConditions.WeatherData.Bus weaBus
        annotation (Placement(transformation(extent={{-112,50},{-92,70}})));
      BaseClasses.GCritCalc gCritCalc(slope=per.slope, y_intercept=per.y_intercept)
        annotation (Placement(transformation(extent={{-64,-18},{-44,2}})));
      Buildings.Utilities.Math.SmoothHeaviside smoothHeaviside(delta=conDel)
        annotation (Placement(transformation(extent={{28,-10},{48,10}})));
      Modelica.Blocks.Math.Add add(k2=-1)
        annotation (Placement(transformation(extent={{-22,-10},{-2,10}})));

    equation
      connect(TIn, gCritCalc.TIn) annotation (Line(
          points={{-120,-40},{-84,-40},{-84,-14},{-66,-14}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(weaBus.TDryBul, gCritCalc.TEnv) annotation (Line(
          points={{-102,60},{-84,60},{-84,-2},{-66,-2}},
          color={255,204,51},
          thickness=0.5,
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}}));
      connect(gCritCalc.GCrit, add.u2) annotation (Line(
          points={{-42.4,-8},{-32,-8},{-32,-6},{-24,-6}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(weaBus.HDirNor, add.u1) annotation (Line(
          points={{-102,60},{-34,60},{-34,6},{-24,6}},
          color={255,204,51},
          thickness=0.5,
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}}));
      connect(smoothHeaviside.y, conSig) annotation (Line(
          points={{49,0},{118,0}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(add.y, smoothHeaviside.u) annotation (Line(
          points={{-1,0},{26,0}},
          color={0,0,127},
          smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}),
                          graphics),
      defaultComponentName = "pumpCon",
      Documentation(info = "<html>
  <p>
  This component models a pump controller which might be used in a solar thermal system. It sets a flow rate for the system and controls whether the pump is active or inactive.
  The pump is activated when the incident solar radiation is greater than the critical radiation and the inlet temperature is lower than a user specified value.
  </p>
  <h4>Equations</h4>
  <p>
  The critical radiation is defined per Duffe and Beckman. It is calculated using Equation 6.8.2.
  </p>
  <p align=\"center\" style=\"font-style:italic;\">
  G<sub>TC</sub>=(F<sub>R</sub>U<sub>L</sub>*(T<sub>i</sub>-T<sub>a</sub>))/(F<sub>R</sub>(&tau;&alpha;))
  </p>
  <h4>References</h4>
  <p>
  J.A. Duffie and W.A. Beckman 2006, Solar Engineering of Thermal Processes (3rd Edition), John Wiley & Sons, Inc.
  </p>
  </html>",
      revisions = "<html>
  <ul>
  <li>
  January 15, 2013 by Peter Grant <br>
  First implementation
  </li>
  </ul>
  </html>"));
    end SolarPumpController;

    package Examples
      extends Modelica.Icons.ExamplesPackage;
      model SolarPumpController
        "Example showing the use of CriticalSolarPumpController"
        import Buildings;
        extends Modelica.Icons.Example;
        Buildings.Fluid.SolarCollectors.Controls.SolarPumpController
                                                           pumCon(per=
              Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate.SRCC2001002B(),conDel=
             0.01)
          annotation (Placement(transformation(extent={{-6,0},{14,20}})));
        Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam="Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
          annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
        Modelica.Blocks.Sources.Sine sine(
          amplitude=20,
          offset=273.15 + 30,
          freqHz=0.0001)
          annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
      equation
        connect(weaDat.weaBus, pumCon.weaBus)                      annotation (Line(
            points={{-40,30},{-20,30},{-20,16},{-6.2,16}},
            color={255,204,51},
            thickness=0.5,
            smooth=Smooth.None));
        connect(sine.y, pumCon.TIn)                      annotation (Line(
            points={{-39,-10},{-20,-10},{-20,6},{-8,6}},
            color={0,0,127},
            smooth=Smooth.None));
        annotation (Diagram(graphics), Commands(file=
                "Resources/Scripts/Dymola/Fluid/SolarCollector/Controls/Examples/CriticalSolarPumpController.mos"
              "Simulate and Plot"),
              Documentation(info="<html>
        <p>
        This model provides an example of how the SolarPumpController model is used. In it a SolarPumpController model reads weather data and inlet temperature data to determine
        whether the pump should be active or not.<br>
        </p>
        </html>",
              revisions="<html>
        <ul>
        <li>
        Mar 27, 2013 by Peter Grant:<br>
        First implementation
        </ul>
        </li>
        </html>"));
      end SolarPumpController;
    end Examples;
  end Controls;

  package Examples
    "Collection of models that illustrate model use and test models"
  extends Modelica.Icons.ExamplesPackage;

    model FlatPlateSolarCollector "Test model for FlatPlateSolarCollector"
      import Buildings;
      extends Modelica.Icons.Example;
      replaceable package Medium = Buildings.Media.ConstantPropertyLiquidWater;
      Buildings.Fluid.SolarCollectors.FlatPlate         solCol(
        redeclare package Medium = Medium,
        nSeg=3,
        Cp=4189,
        shaCoe=0,
        I_nominal=800,
        from_dp=true,
        per=Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate.SRCC2001002B(),
        energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
        lat=0.73097781993588,
        azi=0.3,
        til=0.5,
        TEnv_nominal=283.15,
        TIn_nominal=293.15)
                 annotation (Placement(transformation(extent={{-20,-20},{0,0}})));

      Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
            "Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
        annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
      Buildings.Fluid.Sources.Boundary_pT sin(
        redeclare package Medium = Medium,
        use_p_in=false,
        p(displayUnit="Pa") = 101325,
        nPorts=1) annotation (Placement(transformation(extent={{80,-20},{60,0}},
              rotation=0)));
      inner Modelica.Fluid.System system(p_ambient=101325) annotation (Placement(
            transformation(extent={{60,60},{80,80}}, rotation=0)));
      Buildings.Fluid.Sensors.TemperatureTwoPort TOut(
        redeclare package Medium = Medium,
        T_start(displayUnit="K"),
        m_flow_nominal=solCol.m_flow_nominal) "Temperature sensor"
        annotation (Placement(transformation(extent={{20,-20},{40,0}})));
      Buildings.Fluid.Sensors.TemperatureTwoPort TIn(redeclare package Medium
          = Medium, m_flow_nominal=solCol.m_flow_nominal) "Temperature sensor"
        annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
      Buildings.Fluid.Sources.Boundary_pT sou(
        redeclare package Medium = Medium,
        T=273.15 + 10,
        use_p_in=false,
        nPorts=1,
        p(displayUnit="Pa") = 101325 + 2*solCol.dp_nominal) annotation (Placement(
            transformation(
            extent={{10,-10},{-10,10}},
            rotation=180,
            origin={-90,-10})));
    equation
      connect(solCol.port_b, TOut.port_a) annotation (Line(
          points={{0,-10},{20,-10}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(TOut.port_b, sin.ports[1]) annotation (Line(
          points={{40,-10},{60,-10}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(TIn.port_b, solCol.port_a) annotation (Line(
          points={{-40,-10},{-20,-10}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(sou.ports[1], TIn.port_a) annotation (Line(
          points={{-80,-10},{-60,-10}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(weaDat.weaBus, solCol.weaBus) annotation (Line(
          points={{-20,30},{-7.4,30},{-7.4,0}},
          color={255,204,51},
          thickness=0.5,
          smooth=Smooth.None));
      annotation (
        Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
                100}}), graphics),
        Documentation(info="<html>
<p>
This examples demonstrates the implementation of <a href=\"modelica://Buildings.Fluid.SolarCollectors.FlatPlate\"> Buildings.Fluid.SolarCollectors.FlatPlate</a>. In it water is passed through a solar collector while being heated by the sun in the San Francisco, CA,
 USA climate.
</p>
</html>",    revisions="<html>
<ul>
<li>
Mar 27, 2013, by Peter Grant:<br>
First implementation.
</li>
</ul>
</html>"),
        __Dymola_Commands(file=
              "Resources/Scripts/Dymola/Fluid/SolarCollector/Examples/FlatPlateSolarCollector.mos"
            "Simulate and Plot"),
        Icon(graphics));
    end FlatPlateSolarCollector;

    model TubularSolarCollector
      "Example showing the simulation of a tubular collector"
      import Buildings;
      extends Modelica.Icons.Example;
      replaceable package Medium = Buildings.Media.ConstantPropertyLiquidWater;
      Buildings.Fluid.SolarCollectors.Tubular           solCol(
        redeclare package Medium = Medium,
        nSeg=3,
        Cp=4189,
        shaCoe=0,
        I_nominal=800,
        per=Buildings.Fluid.SolarCollectors.Data.Tubular.SRCC2012033A(),
        energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
        lat=0.73097781993588,
        azi=0.3,
        til=0.5,
        TEnv_nominal=283.15,
        TIn_nominal=293.15)
                 annotation (Placement(transformation(extent={{-12,-20},{8,0}})));
      Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
            "Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
        annotation (Placement(transformation(extent={{-32,20},{-12,40}})));
      Buildings.Fluid.Sources.Boundary_pT sin(
        redeclare package Medium = Medium,
        use_p_in=false,
        p(displayUnit="Pa") = 101325,
        nPorts=1) annotation (Placement(transformation(extent={{88,-20},{68,0}},
              rotation=0)));
      inner Modelica.Fluid.System system(p_ambient=101325) annotation (Placement(
            transformation(extent={{68,60},{88,80}}, rotation=0)));
      Buildings.Fluid.Sensors.TemperatureTwoPort TOut(
        redeclare package Medium = Medium,
        T_start(displayUnit="K"),
        m_flow_nominal=solCol.m_flow_nominal) "Temperature sensor"
        annotation (Placement(transformation(extent={{28,-20},{48,0}})));
      Buildings.Fluid.Sensors.TemperatureTwoPort TIn(redeclare package Medium
          = Medium, m_flow_nominal=solCol.m_flow_nominal) "Temperature sensor"
        annotation (Placement(transformation(extent={{-52,-20},{-32,0}})));
      Buildings.Fluid.Sources.Boundary_pT sou(
        redeclare package Medium = Medium,
        T=273.15 + 10,
        use_p_in=false,
        nPorts=1,
        p(displayUnit="Pa") = 101325 + 2*solCol.dp_nominal) annotation (Placement(
            transformation(
            extent={{10,-10},{-10,10}},
            rotation=180,
            origin={-82,-10})));
    equation
      connect(solCol.port_b,TOut. port_a) annotation (Line(
          points={{8,-10},{28,-10}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(TOut.port_b,sin. ports[1]) annotation (Line(
          points={{48,-10},{68,-10}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(TIn.port_b,solCol. port_a) annotation (Line(
          points={{-32,-10},{-12,-10}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(sou.ports[1],TIn. port_a) annotation (Line(
          points={{-72,-10},{-52,-10}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(weaDat.weaBus,solCol. weaBus) annotation (Line(
          points={{-12,30},{0.6,30},{0.6,0}},
          color={255,204,51},
          thickness=0.5,
          smooth=Smooth.None));
      annotation (Commands(file=
              "Resources/Scripts/Dymola/Fluid/SolarCollector/Examples/TubularSolarCollector.mos"
            "Simulate and Plot"),
            Documentation(info="<html>
        <p>
        This model demonstrates the implementation of <a href=\"modelica://Buildings.Fluid.SolarCollectors.Tubular\">Buildings.Fluid.SolarCollectors.Tubular</a>. In it water is passed through a tubular solar collector while being heated by the sun in
        the San Francisco, CA, USA climate.<br>
        </p>
        </html>",
            revisions="<html>
        <ul>
        <li>
        Mar 27, 2013 by Peter Grant:<br>
        First implementation
        </li>
        </ul>
        </html>"));
    end TubularSolarCollector;

    model ConcentratingSolarCollector
      "Example showing the use of ConcentratingSolarCollector"
      import Buildings;
      extends Modelica.Icons.Example;
      replaceable package Medium = Buildings.Media.ConstantPropertyLiquidWater;
      Buildings.Fluid.SolarCollectors.Concentrating     solCol(
        redeclare package Medium = Medium,
        nSeg=3,
        Cp=4189,
        shaCoe=0,
        I_nominal=800,
        per=Buildings.Fluid.SolarCollectors.Data.Concentrating.SRCC2011127A(),
        energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
        lat=0.73097781993588,
        azi=0.3,
        til=0.5,
        TEnv_nominal=283.15,
        TMean_nominal=293.15)
                 annotation (Placement(transformation(extent={{-14,-20},{6,0}})));
      Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
            "Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
        annotation (Placement(transformation(extent={{-34,20},{-14,40}})));
      Buildings.Fluid.Sources.Boundary_pT sin(
        redeclare package Medium = Medium,
        use_p_in=false,
        p(displayUnit="Pa") = 101325,
        nPorts=1) annotation (Placement(transformation(extent={{86,-20},{66,0}},
              rotation=0)));
      inner Modelica.Fluid.System system(p_ambient=101325) annotation (Placement(
            transformation(extent={{66,60},{86,80}}, rotation=0)));
      Buildings.Fluid.Sensors.TemperatureTwoPort TOut(
        redeclare package Medium = Medium,
        T_start(displayUnit="K"),
        m_flow_nominal=solCol.m_flow_nominal) "Temperature sensor"
        annotation (Placement(transformation(extent={{26,-20},{46,0}})));
      Buildings.Fluid.Sensors.TemperatureTwoPort TIn(redeclare package Medium
          = Medium, m_flow_nominal=solCol.m_flow_nominal) "Temperature sensor"
        annotation (Placement(transformation(extent={{-54,-20},{-34,0}})));
      Buildings.Fluid.Sources.Boundary_pT sou(
        redeclare package Medium = Medium,
        T=273.15 + 10,
        use_p_in=false,
        nPorts=1,
        p(displayUnit="Pa") = 101325 + 2*solCol.dp_nominal) annotation (Placement(
            transformation(
            extent={{10,-10},{-10,10}},
            rotation=180,
            origin={-84,-10})));
    equation
      connect(solCol.port_b,TOut. port_a) annotation (Line(
          points={{6,-10},{26,-10}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(TOut.port_b,sin. ports[1]) annotation (Line(
          points={{46,-10},{66,-10}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(TIn.port_b,solCol. port_a) annotation (Line(
          points={{-34,-10},{-14,-10}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(sou.ports[1],TIn. port_a) annotation (Line(
          points={{-74,-10},{-54,-10}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(weaDat.weaBus,solCol. weaBus) annotation (Line(
          points={{-14,30},{-1.4,30},{-1.4,0}},
          color={255,204,51},
          thickness=0.5,
          smooth=Smooth.None));
      annotation (Commands(file=
              "Resources/Scripts/Dymola/Fluid/SolarCollector/Examples/ConcentratingSolarCollector.mos"
            "Simulate and Plot"),
            Documentation(info="<html>
        <p>
        This model demonstrates the implementation of <a href=\"modelica://Buildings.Fluid.SolarCollectors.Concentrating\">Buildings.Fluid.SolarCollectors.Concentrating</a>. In it water is passed through the solar collector while being heated by the sun in
        the San Francisco, CA, USA climate.<br>
        </p>
        </html>",
            revisions="<html>
        <ul>
        <li>
        Mar 27, 2013 by Peter Grant:<br>
        First implementation
        </li>
        </ul>
        </html>"));
    end ConcentratingSolarCollector;

    model FlatPlateWithTank
      "Example showing use of the flat plate solar collector"
      import Buildings;
      extends Modelica.Icons.Example;
      replaceable package Medium = Buildings.Media.ConstantPropertyLiquidWater;
      replaceable package Medium_2 =
          Buildings.Media.ConstantPropertyLiquidWater;

      Buildings.Fluid.SolarCollectors.FlatPlate         solCol(
        nSeg=3,
        Cp=4189,
        shaCoe=0,
        I_nominal=800,
        redeclare package Medium = Medium_2,
        per=Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate.SRCC2002001J(),
        energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
        lat=0.73097781993588,
        azi=0.3,
        til=0.78539816339745,
        TEnv_nominal=283.15,
        TIn_nominal=293.15)
                 annotation (Placement(transformation(extent={{-2,46},{18,66}})));
      BoundaryConditions.WeatherData.ReaderTMY3           weaDat(filNam="Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos",
          computeWetBulbTemperature=false)
        annotation (Placement(transformation(extent={{-30,80},{-10,100}})));
      inner Modelica.Fluid.System system(p_ambient=101325) annotation (Placement(
            transformation(extent={{70,68},{90,88}}, rotation=0)));
      Sensors.TemperatureTwoPort                 TOut(
        T_start(displayUnit="K"),
        m_flow_nominal=solCol.m_flow_nominal,
        redeclare package Medium = Medium_2) "Temperature sensor"
        annotation (Placement(transformation(extent={{30,46},{50,66}})));
      Sensors.TemperatureTwoPort                 TIn(
                    m_flow_nominal=solCol.m_flow_nominal, redeclare package
          Medium =
            Medium_2) "Temperature sensor"
        annotation (Placement(transformation(extent={{-34,46},{-14,66}})));
      Buildings.Fluid.Storage.StratifiedEnhancedInternalHX
                                 tan(
        nSeg=4,
        redeclare package Medium = Medium,
        hTan=1,
        m_flow_nominal=0.1,
        VTan=1.5,
        dIns=0.07,
        redeclare package Medium_2 = Medium_2,
        C=200,
        m_flow_nominal_HX=0.1,
        m_flow_nominal_tank=0.1,
        UA_nominal=300,
        ASurHX=0.199,
        dHXExt=0.01905,
        HXTopHeight=0.9,
        HXBotHeight=0.65,
        energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
        T_start=293.15)
                     annotation (Placement(transformation(
            extent={{-15,-15},{15,15}},
            rotation=180,
            origin={27,-33})));
      Buildings.Fluid.SolarCollectors.Controls.SolarPumpController
                                                         pumCon(
        per=Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate.SRCC2001002B(),conDel=
           0.0001) "Pump controller"                                                              annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={-88,50})));
      Modelica.Blocks.Sources.Constant TRoo(k=273.15 + 20) "Room temperature"
        annotation (Placement(transformation(extent={{-72,-92},{-52,-72}})));
      Buildings.HeatTransfer.Sources.PrescribedTemperature rooT
        annotation (Placement(transformation(extent={{-40,-92},{-20,-72}})));
      Modelica.Blocks.Math.Gain gain(k=0.04)
                                     annotation (Placement(transformation(
            extent={{-8,-8},{8,8}},
            rotation=270,
            origin={-88,10})));
      Buildings.Fluid.Sources.Boundary_pT bou(nPorts=1, redeclare package
          Medium =
            Medium) annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={0,6})));
      Buildings.Fluid.Sources.MassFlowSource_T bou1(
        nPorts=1,
        redeclare package Medium = Medium,
        use_m_flow_in=false,
        m_flow=0.01,
        T=288.15) annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={44,6})));
      Buildings.Fluid.Movers.FlowMachine_m_flow pum(redeclare package Medium =
            Medium_2, m_flow_nominal=0.1) annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=90,
            origin={-50,-6})));
      Buildings.Fluid.Storage.ExpansionVessel exp(redeclare package Medium =
            Medium_2, VTot=0.1,
        energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
                                annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=90,
            origin={-60,-48})));
    equation
      connect(solCol.port_b,TOut. port_a) annotation (Line(
          points={{18,56},{30,56}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(TIn.port_b,solCol. port_a) annotation (Line(
          points={{-14,56},{-2,56}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(weaDat.weaBus,solCol. weaBus) annotation (Line(
          points={{-10,90},{10.6,90},{10.6,66}},
          color={255,204,51},
          thickness=0.5,
          smooth=Smooth.None));
      connect(TIn.T, pumCon.TIn) annotation (Line(
          points={{-24,67},{-24,78},{-92,78},{-92,62}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(weaDat.weaBus, pumCon.weaBus) annotation (Line(
          points={{-10,90},{-6,90},{-6,72},{-82,72},{-82,60.2}},
          color={255,204,51},
          thickness=0.5,
          smooth=Smooth.None));
      connect(TRoo.y, rooT.T)                  annotation (Line(
          points={{-51,-82},{-42,-82}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(rooT.port, tan.heaPorTop)                  annotation (Line(
          points={{-20,-82},{24,-82},{24,-44.1}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(rooT.port, tan.heaPorSid)                  annotation (Line(
          points={{-20,-82},{18.6,-82},{18.6,-33}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(pumCon.conSig, gain.u) annotation (Line(
          points={{-88,38.2},{-88,19.6}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(bou.ports[1], tan.port_b) annotation (Line(
          points={{-1.33227e-15,-4},{-1.33227e-15,-16},{0,-16},{0,-33},{12,-33}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(bou1.ports[1], tan.port_a) annotation (Line(
          points={{44,-4},{46,-4},{46,-33},{42,-33}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(gain.y, pum.m_flow_in) annotation (Line(
          points={{-88,1.2},{-88,-6.2},{-62,-6.2}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(pum.port_b, TIn.port_a) annotation (Line(
          points={{-50,4},{-50,56},{-34,56}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(pum.port_a, exp.port_a) annotation (Line(
          points={{-50,-16},{-50,-48}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(exp.port_a, tan.port_b1) annotation (Line(
          points={{-50,-48},{13.5,-48}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(TOut.port_b, tan.port_a1) annotation (Line(
          points={{50,56},{62,56},{62,-48},{40.5,-48}},
          color={0,127,255},
          smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}),
                          graphics), Commands(file=
              "Resources/Scripts/Dymola/Fluid/SolarCollector/Examples/FlatPlateWithTank.mos"
            "Simulate and Plot"),
            Documentation(info="<html>
        <p>
        This model shows how several different examples can be combined to create an entire solar water heating system. The <a href=\"modelica://Buildings.Fluid.Storage.StratifiedEnhancedInternalHX\">
        StratifiedEnhancedInternalHX</a> (tan) model is used to represent the tank filled with hot water. A loop, powered by a <a href=\"modelica://Buildings.Fluid.Movers.FlowMachine_m_flow\">pump</a>
        (pum) passes the water through an <a href=\"modelica://Buildings.Fluid.Storage.ExpansionVessel\"> expansion tank</a> (exp), a <a href=\"modelica://Buildings.Fluid.Sensors.TemperatureTwoPort\"> 
        temperature sensor</a> (TIn), the <a href=\"modelica://Buildings.Fluid.SolarCollectors.FlatPlate\"> solar collector</a> (solCol) and a second <a href=\"modelica://Buildings.Fluid.Sensors.TemperatureTwoPort\">
         temperature sensor</a> (TOut) before re-entering the tank.
        </p>
        <p>
        The solar collector is connected to the <a href=\"modelica://Buildings.BoundaryConditions.WeatherData.ReaderTMY3\"> weather model</a> (weaDat) which passes information for the San Francisco, CA, USA climate. This information is used to identify both
        the heat gain in the water from the sun and the heat loss to the ambient conditions.
        </p>
        <p>
        The flow rate through the pump is controlled the <a href=\"modelica://Buildings.Fluid.SolarCollectors.Controls.SolarPumpController\"> SolarPumpController </a> model (pumCon) and a gain model. The SolarPumpController outputs a binary on (1) / off (0) signal. The
        on/off signal is passed through the gain model, multiplying by 0.04, to represent a flow rate of 0.04 kg/s when the pump is active.
        </p>
        <p>
        The heat ports for the tank are connected to an ambient temperature of 20 degrees C representing the temperature of the room the tank is stored in.
        </p>
        <p>
        bou1 provides a constant mass flow rate for a hot water draw while bou provides an outlet boundary condition for the outlet of the draw.<br>
        </p>
        </html>",
            revisions="<html>
        <ul>
        <li>
        Mar 27, 2013 by Peter Grant:<br>
        First implementation
        </li>
        </ul>
        </html>"));
    end FlatPlateWithTank;

    model FlatPlateSolarCollectorValidation
      "Test model for FlatPlateSolarCollector"
      import Buildings;
      extends Modelica.Icons.Example;
      replaceable package Medium = Buildings.Media.ConstantPropertyLiquidWater;
      Real Q_Use = -boundary.m_flow_in * 4190*(boundary.T_in-TOut.T)/3.6;
      Real SumHeaGai;
      Buildings.Fluid.SolarCollectors.Examples.BaseClasses.FlatPlateValidation
                                                        solCol(
        redeclare package Medium = Medium,
        Cp=4189,
        shaCoe=0,
        azi=0,
        per=Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate.TRNSYSValidation(),
        nSeg=3,
        I_nominal=800,
        energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
        lat=0.6457718232379,
        til=0.78539816339745,
        TEnv_nominal=283.15,
        TIn_nominal=293.15)
                 annotation (Placement(transformation(extent={{32,-20},{52,0}})));

      Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
            "Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
        annotation (Placement(transformation(extent={{-20,20},{0,40}})));
      Buildings.Fluid.Sources.Boundary_pT sin(
        redeclare package Medium = Medium,
        use_p_in=false,
        p(displayUnit="Pa") = 101325,
        nPorts=1) annotation (Placement(transformation(extent={{100,-20},{80,0}},
              rotation=0)));
      inner Modelica.Fluid.System system(p_ambient=101325) annotation (Placement(
            transformation(extent={{60,60},{80,80}}, rotation=0)));
      Buildings.Fluid.Sensors.TemperatureTwoPort TOut(
        redeclare package Medium = Medium,
        T_start(displayUnit="K"),
        m_flow_nominal=solCol.m_flow_nominal) "Temperature sensor"
        annotation (Placement(transformation(extent={{56,-20},{76,0}})));
      Buildings.Fluid.Sources.MassFlowSource_T boundary(
        nPorts=1,
        redeclare package Medium = Medium,
        use_m_flow_in=true,
        use_T_in=true)
        annotation (Placement(transformation(extent={{6,-20},{26,0}})));
      Modelica.Blocks.Sources.CombiTimeTable
                                           combiTable1Ds(
        tableOnFile=true,
        tableName="TRNSYS",
        columns=2:5,
        fileName=
            "Fluid/SolarCollector/Examples/ValidationData/TRNSYSAnnualData.txt")
        annotation (Placement(transformation(extent={{-64,-20},{-44,0}})));

      Modelica.Blocks.Math.Add add
        annotation (Placement(transformation(extent={{-30,-50},{-10,-30}})));
      Modelica.Blocks.Sources.Constant const(k=273.15)
        annotation (Placement(transformation(extent={{-82,-56},{-62,-36}})));

    equation
        SumHeaGai = sum(solCol.solHeaGai.QSol_flow[1:3]);

      connect(solCol.port_b, TOut.port_a) annotation (Line(
          points={{52,-10},{56,-10}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(TOut.port_b, sin.ports[1]) annotation (Line(
          points={{76,-10},{80,-10}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(weaDat.weaBus, solCol.weaBus) annotation (Line(
          points={{4.44089e-16,30},{44.6,30},{44.6,0}},
          color={255,204,51},
          thickness=0.5,
          smooth=Smooth.None));
      connect(boundary.ports[1], solCol.port_a) annotation (Line(
          points={{26,-10},{32,-10}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(const.y, add.u2) annotation (Line(
          points={{-61,-46},{-32,-46}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(add.y, boundary.T_in) annotation (Line(
          points={{-9,-40},{-6,-40},{-6,-6},{4,-6}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(combiTable1Ds.y[1], add.u1) annotation (Line(
          points={{-43,-10},{-36,-10},{-36,-34},{-32,-34}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(combiTable1Ds.y[4], boundary.m_flow_in) annotation (Line(
          points={{-43,-10},{-26,-10},{-26,-2},{6,-2}},
          color={0,0,127},
          smooth=Smooth.None));
      annotation (
        Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,
                100}}), graphics),
        Documentation(info="<html>
<p>
This model was used to validate the <a href=\"modelica://Buildings.Fluid.SolarCollectors.FlatPlate\"> Buildings.Fluid.SolarCollectors.FlatPlate</a> solar collector model against TRNSYS data.
Data files are used to ensure that the FlatPlate solar collector model saw the same inlet and weather conditions as the TRNSYS simulation. A special version of the
<a href=\"modelica://Buildings.Fluid.SolarCollectors.FlatPlate\"> Buildings.Fluid.SolarCollectors.FlatPlate</a> solar collector model was made to accomodate the data files. It 
can be accessed in the BaseClasses folder.
</p>
</html>",    revisions="<html>
<ul>
<li>
Mar 27, 2013, by Peter Grant:<br>
First implementation.
</li>
</ul>
</html>"),
        __Dymola_Commands(file=
              "Resources/Scripts/Dymola/Fluid/SolarCollector/Examples/FlatPlateSolarCollectorValidation.mos"
            "Simulate and Plot"),
        Icon(graphics));
    end FlatPlateSolarCollectorValidation;

    package BaseClasses
      extends Modelica.Icons.BasesPackage;
      model FlatPlateValidation "Model of a flat plate solar thermal collector"
        import Buildings;
        extends
          Buildings.Fluid.SolarCollectors.BaseClasses.PartialSolarCollector(     perPar=per);
        parameter Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate.Generic               per
          "Performance data"  annotation (choicesAllMatching=true);
        parameter Modelica.SIunits.Temperature TIn_nominal
          "Inlet temperature at nominal condition";
        Buildings.Fluid.SolarCollectors.BaseClasses.ASHRAESolarGain
          solHeaGai(
          B0=per.B0,
          B1=per.B1,
          shaCoe=shaCoe,
          til=til,
          nSeg=nSeg,
          y_intercept=per.y_intercept,
          A_c=per.A)
                   annotation (Placement(transformation(extent={{12,60},{32,80}})));
      public
        Buildings.Fluid.SolarCollectors.BaseClasses.EN12975HeatLoss heaLos(
          Cp=Cp,
          nSeg=nSeg,
          I_nominal=I_nominal,
          TEnv_nominal=TEnv_nominal,
          A_c=per.A,
          y_intercept=per.y_intercept,
          m_flow_nominal=rho*per.VperA_flow_nominal*per.A,
          C1=3.611111,
          C2=0.07,
          TMean_nominal=TIn_nominal)
              annotation (Placement(transformation(extent={{0,20},{20,40}})));

      equation
        connect(solHeaGai.QSol_flow, heaGai.Q_flow) annotation (Line(
            points={{33,70},{38,70}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(temSen.T, heaLos.TFlu) annotation (Line(
            points={{-4,-16},{-16,-16},{-16,24},{-2,24}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(HDirTil.inc, solHeaGai.incAng) annotation (Line(
            points={{-59,52},{-32,52},{-32,66},{10,66}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(HDirTil.H, solHeaGai.HDirTil) annotation (Line(
            points={{-59,56},{-40,56},{-40,72},{10,72}},
            color={0,0,127},
            smooth=Smooth.None));

        connect(HDifTilIso.HGroDifTil, solHeaGai.HGroDifTil) annotation (Line(
            points={{-59,76},{-32,76},{-32,74.8},{10,74.8}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(HDifTilIso.HSkyDifTil, solHeaGai.HSkyDifTil) annotation (Line(
            points={{-59,88},{-16,88},{-16,78},{10,78}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(weaBus.TDryBul, heaLos.TEnv) annotation (Line(
            points={{-100,78},{-88,78},{-88,36},{-2,36}},
            color={255,204,51},
            thickness=0.5,
            smooth=Smooth.None), Text(
            string="%first",
            index=-1,
            extent={{-6,3},{-6,3}}));
        connect(heaLos.QLos, QLos.Q_flow) annotation (Line(
            points={{21,30},{38,30}},
            color={0,0,127},
            smooth=Smooth.None));
        annotation (
          Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
                  100,100}}),
                  graphics),
          Icon(graphics={
              Rectangle(
                extent={{-86,100},{88,-100}},
                lineColor={215,215,215},
                fillColor={215,215,215},
                fillPattern=FillPattern.Solid),
              Rectangle(
                extent={{-10,80},{10,-100}},
                lineColor={215,215,215},
                fillColor={135,135,135},
                fillPattern=FillPattern.Solid),
              Rectangle(
                extent={{30,80},{50,-100}},
                lineColor={215,215,215},
                fillColor={135,135,135},
                fillPattern=FillPattern.Solid),
              Rectangle(
                extent={{-50,80},{-28,-100}},
                lineColor={215,215,215},
                fillColor={135,135,135},
                fillPattern=FillPattern.Solid),
              Rectangle(
                extent={{-60,100},{60,80}},
                lineColor={215,215,215},
                fillColor={135,135,135},
                fillPattern=FillPattern.Solid),
              Ellipse(
                extent={{-24,28},{28,-24}},
                lineColor={255,0,0},
                fillColor={255,0,0},
                fillPattern=FillPattern.Solid),
              Line(
                points={{-48,2},{-28,2}},
                color={255,0,0},
                smooth=Smooth.None,
                thickness=1),
              Line(
                points={{34,2},{54,2}},
                color={255,0,0},
                smooth=Smooth.None,
                thickness=1),
              Line(
                points={{-8,-8},{6,6}},
                color={255,0,0},
                smooth=Smooth.None,
                thickness=1,
                origin={30,34},
                rotation=180),
              Line(
                points={{-34,-38},{-18,-22}},
                color={255,0,0},
                smooth=Smooth.None,
                thickness=1),
              Line(
                points={{-8,-8},{6,6}},
                color={255,0,0},
                smooth=Smooth.None,
                thickness=1,
                origin={32,-28},
                rotation=90),
              Line(
                points={{-6,-6},{8,8}},
                color={255,0,0},
                smooth=Smooth.None,
                thickness=1,
                origin={-22,32},
                rotation=90),
              Line(
                points={{-10,0},{10,0}},
                color={255,0,0},
                smooth=Smooth.None,
                thickness=1,
                origin={4,-38},
                rotation=90),
              Line(
                points={{-10,0},{10,0}},
                color={255,0,0},
                smooth=Smooth.None,
                thickness=1,
                origin={2,42},
                rotation=90)}),
          defaultComponentName="solCol",
          Documentation(info="<html>
<h4>Overview</h4>
<p>
This component models the flat plate solar thermal collector. By default this model uses ASHRAE 93 ratings data and references the <a href=\"modelica://Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate\">
Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate</a> data library.
</p>
<h4>Notice</h4>
<p>
1. As metioned in the reference, the SRCC incident angle modifier equation coefficients are only valid for incident angles of 60 degrees or less. 
Because these curves can be valid yet behave poorly for angles greater than 60 degrees the model cuts off collectors' gains of both direct and diffuse solar radiation for incident angles greater than 60 degrees. 
<br>
2. By default, the esitimated heat capacity of the collector without fluid is calculated based on the dry mass and the specific heat capacity of copper.
<h4>References</h4>
<p>
<a href=\"http://www.energyplus.gov\">EnergyPlus 7.0.0 Engineering Reference</a>, October 13, 2011.
<br>
J.A. Duffie and W.A. Beckman 2006, Solar Engineering of Thermal Processes (3rd Edition), John Wiley & Sons, Inc.  
</p>
</html>",       revisions="<html>
<ul>
<li>
January 4, 2013, by Peter Grant:<br>
First implementation.
</li>
</ul>
</html>"));
      end FlatPlateValidation;
    end BaseClasses;
  annotation (preferedView="info", Documentation(info="<html>
<p>
This package contains examples for the use of models that can be found in <a href=\"modelica://Buildings.Fluid.SolarCollector\"> Buildings.Fluid.SolarCollector. 
</p>
</html>"));
  end Examples;

  package Data "Data for solar thermal collectors"
  extends Modelica.Icons.MaterialPropertiesPackage;

    package GlazedFlatPlate
      "Package with SRCC rating information for glazed flat-plate solar thermal collector"
    extends Modelica.Icons.MaterialPropertiesPackage;

      record Generic "Variable types for data records from SRCC data"
        extends Modelica.Icons.Record;
        parameter Buildings.Fluid.SolarCollectors.Types.Area ATyp
          "Gross or aperture area";
        parameter Buildings.Fluid.SolarCollectors.Types.DesignFluid Fluid
          "Specifies the fluid the heater is desnigned to use";
        parameter Modelica.SIunits.Area A "Area";
        parameter Modelica.SIunits.Mass mDry "Dry weight";
        parameter Modelica.SIunits.Volume V "Fluid volume";
        parameter Modelica.SIunits.Pressure dp_nominal
          "Pressure drop during test";
        parameter Real VperA_flow_nominal(unit="m/s")
          "Volume flow rate per area of test flow";
        parameter Real B0 "1st incident angle modifier coefficient";
        parameter Real B1 "2nd incident angle modifier coefficient";
        parameter Real y_intercept "Y intercept (Maximum efficiency)";
        parameter Real slope(unit = "W/(m2.K)") "Slope from rating data";
        parameter Real IAMDiff
          "Incidence angle modifier from EN12975 ratings data";
        parameter Real C1 "Heat loss coefficient from EN12974 ratings data";
        parameter Real C2
          "Temperature dependance of heat loss from EN12975 ratings data";
        annotation (defaultComponentName="gas", Documentation(info="<html>
Generic record for solar information from SRCC certified solar collectors. This generic record is intended for flat plate collectors using data collected according to ASHRAE93.
The implementation is according to 
<a href=\"http://www.solar-rating.org/ratings/og100.html\">SRCC OG-100 Directory, 
SRCC Certified Solar Collecotr Ratings</a>.
</html>",       revisions="<html>
<ul>
<li>
Feb 28, 2013, by Peter Grant:<br>
First implementation.
</li>
</ul>
</html>"));
      end Generic;

      record SRCC2001002B =
          Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate.Generic (
          ATyp=Types.Area.Gross,
          Fluid=Types.DesignFluid.Water,
          A=0.933,
          mDry=8.6,
          V=0.6/1000,
          dp_nominal=1103*1000,
          VperA_flow_nominal=16.9/(10^6),
          B0=-0.194,
          B1=-0.019,
          y_intercept=0.602,
          slope=-3.764,
          IAMDiff=0,
          C1=0,
          C2=0) "Water-based, ACR Solar International: Skyline 10-01"
          annotation(Documentation(info = "<html>
    <h4>Citation</h4>
    <p>
    Ratings data taken from the Solar Rating Certification Corporation website. SRCC# = 2001002B.<br>
    </p>
    </html>"));
      record SRCC2007064A =
          Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate.Generic (
          ATyp=Types.Area.Gross,
          Fluid=Types.DesignFluid.Air,
          A=34.495,
          mDry=471.7,
          V=34.495*0.04,
          dp_nominal=0,
          VperA_flow_nominal=5062.2/(10^6),
          B0=-0.10,
          B1=0.0,
          y_intercept=0.515,
          slope=-6.36,
          IAMDiff=0,
          C1=0,
          C2=0) "Air-Based, EchoFirst Inc.: Cleanline-Thermal CL-T-30"
          annotation(Documentation(info = "<html>
    <h4>Citation</h4>
    <p>
    Ratings data taken from the Solar Rating Certification Corporation website. SRCC# = 2007064A.<br>
    </p>
    </html>"));
      record SRCC2002001J =
          Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate.Generic (
          ATyp=Types.Area.Gross,
          Fluid=Types.DesignFluid.Water,
          A=1.438,
          mDry=26.76,
          V=2.6/1000,
          dp_nominal=1103*1000,
          VperA_flow_nominal=20.1/(10^6),
          B0=-0.1958,
          B1=-0.0036,
          y_intercept=0.703,
          slope=-4.902,
          IAMDiff=0,
          C1=0,
          C2=0) "Alternate Energy, AE-16"
          annotation(Documentation(info = "<html>
    <h4>Citation</h4>
    <p>
    Ratings data taken from the Solar Rating Certification Corporation website. SRCC# = 2002001J.<br>
    </p>
    </html>"));
      record SRCC1999003F =
          Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate.Generic (
          ATyp=Types.Area.Gross,
          Fluid=Types.DesignFluid.Water,
          A=2.918,
          mDry=69,
          V=8.8/1000,
          dp_nominal=552*1000,
          VperA_flow_nominal=18.4/(10^6),
          B0=-0.1089,
          B1=-0.0002,
          y_intercept=0.708,
          slope=-6.110,
          IAMDiff=0,
          C1=0,
          C2=0) "R&R Solar Supply, Copper Star 32, EPI-308CU(4'x8')"
          annotation(Documentation(info = "<html>
    <h4>Citation</h4>
    <p>
    Ratings data taken from the Solar Rating Certification Corporation website. SRCC# = 1999003F.<br>
    </p>
    </html>"));
      record SRCC2012025I =
          Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate.Generic (
          ATyp=Types.Area.Gross,
          Fluid=Types.DesignFluid.Water,
          A=0.8,
          mDry=15,
          V=1.1/1000,
          dp_nominal=900*1000,
          VperA_flow_nominal=19.7/(10^6),
          B0=-0.4677,
          B1=-0.0002,
          y_intercept=0.582,
          slope=-3.822,
          IAMDiff=0,
          C1=0,
          C2=0) "Boen Solar Technology Co, KLB-1008-E"
          annotation(Documentation(info = "<html>
    <h4>Citation</h4>
    <p>
    Ratings data taken from the Solar Rating Certification Corporation website. SRCC# = 2012025I.<br>
    </p>
    </html>"));
      record TRNSYSValidation =
          Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate.Generic (
          ATyp=Types.Area.Gross,
          Fluid=Types.DesignFluid.Water,
          A=5,
          mDry=8.6,
          V=0.6/1000,
          dp_nominal=1103*1000,
          VperA_flow_nominal=11.1/(10^6),
          B0=-0.2,
          B1=-0,
          y_intercept=0.8,
          slope=-3.6111,
          IAMDiff=0,
          C1=0,
          C2=0) "Default values in the TRNSYS Simulation Studio SDHW example"
          annotation(Documentation(info="<html>
    Default values in the TRNSYS Simualtion Studio SDHW example.</html>"));
    annotation (Documentation(info="<html>
Package with records for SRCC rating information for glazed flat-plate solar thermal collector.
</html>",     revisions="<html>
<ul>
<li>
June 8, 2012, by Wangda Zuo:<br>
First implementation.
</li>
</ul>
</html>"));
    end GlazedFlatPlate;

    package Tubular
    extends Modelica.Icons.MaterialPropertiesPackage;
      record Generic "SRCC rating information for tubular collectors"
        extends Modelica.Icons.Record;
        parameter Buildings.Fluid.SolarCollectors.Types.Area ATyp
          "Gross or aperture area";
        parameter Buildings.Fluid.SolarCollectors.Types.DesignFluid Fluid
          "Specifies the fluid the heater is desnigned to use";
        parameter Modelica.SIunits.Area A "Area";
        parameter Modelica.SIunits.Mass mDry "Dry weight";
        parameter Modelica.SIunits.Volume V "Fluid volume";
        parameter Modelica.SIunits.Pressure dp_nominal
          "Pressure drop during test";
        parameter Real VperA_flow_nominal(unit="m/s")
          "Volume flow rate per area of test flow";
        parameter Real B0 "1st incident angle modifier coefficient";
        parameter Real B1 "2nd incident angle modifer coefficient";
        parameter Real y_intercept "Y intercept (Maximum efficiency)";
        parameter Real slope(unit = "W/(m2.K)") "Slope from rating data";
        parameter Real IAMDiff
          "Incidence angle modifier from EN12975 ratings data";
        parameter Real C1 "Heat loss coefficient from EN12974 ratings data";
        parameter Real C2
          "Temperature dependance of heat loss from EN12975 ratings data";
        annotation (defaultComponentName="gas", Documentation(info="<html>
Generic record for solar information from SRCC certified solar collectors. This generic record is intended for tubular collectors using data collected according to ASHRAE93.
The implementation is according to 
<a href=\"http://www.solar-rating.org/ratings/og100.html\">SRCC OG-100 Directory, 
SRCC Certified Solar Collecotr Ratings</a>.
</html>",       revisions="<html>
<ul>
<li>
Feb 28, 2013, by Peter Grant:<br>
First implementation.
</li>
</ul>
</html>"));
      end Generic;

      record SRCC2012033A =
          Buildings.Fluid.SolarCollectors.Data.Tubular.Generic (
          ATyp=Types.Area.Gross,
          Fluid=Types.DesignFluid.Water,
          A=4.673,
          mDry=111,
          V=2.3/1000,
          dp_nominal=1*1000,
          VperA_flow_nominal=20.1/(10^6),
          B0=1.3766,
          B1=-0.9294,
          y_intercept=0.422,
          slope=-1.864,
          IAMDiff=0,
          C1=0,
          C2=0) "G.S. Inc., Suntask, SR30"
          annotation(Documentation(info = "<html>
    <h4>Citation</h4>
    <p>
    Ratings data taken from the Solar Rating Certification Corporation website. SRCC# = 2012033A.<br>
    </p>
    </html>"));
      record SRCC2012019C =
          Buildings.Fluid.SolarCollectors.Data.Tubular.Generic (
          ATyp=Types.Area.Gross,
          Fluid=Types.DesignFluid.Water,
          A=2.345,
          mDry=46,
          V=0.9/1000,
          dp_nominal=900*1000,
          VperA_flow_nominal=19.9/(10^6),
          B0=0.8413,
          B1=-0.5805,
          y_intercept=0.446,
          slope=-1.635,
          IAMDiff=0,
          C1=0,
          C2=0) "Zhejiang Gaodele New Energy Co, Gaodele, GDL-SP58-1800-15"
          annotation(Documentation(info = "<html>
    <h4>Citation</h4>
    <p>
    Ratings data taken from the Solar Rating Certification Corporation website. SRCC# = 2012019C.<br>
    </p>
    </html>"));
      record SRCC2012005D =
          Buildings.Fluid.SolarCollectors.Data.Tubular.Generic (
          ATyp=Types.Area.Gross,
          Fluid=Types.DesignFluid.Water,
          A=3.431,
          mDry=73,
          V=2/1000,
          dp_nominal=900*1000,
          VperA_flow_nominal=11.1/(10^6),
          B0=1.1803,
          B1=-0.762,
          y_intercept=0.371,
          slope=-1.225,
          IAMDiff=0,
          C1=0,
          C2=0) "Westech Solar Technology Wuxi Co, Westech, WT-B58-20"
          annotation(Documentation(info = "<html>
    <h4>Citation</h4>
    <p>
    Ratings data taken from the Solar Rating Certification Corporation website. SRCC# = 2012005D.<br>
    </p>
    </html>"));
      record SRCC2011133G =
          Buildings.Fluid.SolarCollectors.Data.Tubular.Generic (
          ATyp=Types.Area.Gross,
          Fluid=Types.DesignFluid.Water,
          A=3.624,
          mDry=68,
          V=2.6/1000,
          dp_nominal=900*1000,
          VperA_flow_nominal=17.9/(10^6),
          B0=0.125,
          B1=-0.0163,
          y_intercept=0.609,
          slope=-1.051,
          IAMDiff=0,
          C1=0,
          C2=0) "Evosolar, EVOT-21"
          annotation(Documentation(info = "<html>
    <h4>Citation</h4>
    <p>
    Ratings data taken from the Solar Rating Certification Corporation website. SRCC# = 2011133G.<br>
    </p>
    </html>"));
      record SRCC2011125E =
          Buildings.Fluid.SolarCollectors.Data.Tubular.Generic (
          ATyp=Types.Area.Gross,
          Fluid=Types.DesignFluid.Water,
          A=3.860,
          mDry=77,
          V=2.6/1000,
          dp_nominal=900*1000,
          VperA_flow_nominal=8.4/(10^6),
          B0=0.1405,
          B1=-0.0298,
          y_intercept=0.624,
          slope=-0.975,
          IAMDiff=0,
          C1=0,
          C2=0)
        "Kloben Sud S.r.l., Solar Collectors Sky Pro 1800, Sky Pro 18 CPC 58"
          annotation(Documentation(info = "<html>
    <h4>Citation</h4>
    <p>
    Ratings data taken from the Solar Rating Certification Corporation website. SRCC# = 2011125E.<br>
    </p>
    </html>"));
    end Tubular;

    package Concentrating
      extends Modelica.Icons.MaterialPropertiesPackage;
      record Generic "SRCC rating information for concentrating collectors"
        extends Modelica.Icons.Record;
        parameter Buildings.Fluid.SolarCollectors.Types.Area ATyp
          "Gross or aperture area";
        parameter Buildings.Fluid.SolarCollectors.Types.DesignFluid Fluid
          "Specifies the fluid the heater is desnigned to use";
        parameter Modelica.SIunits.Area A "Area";
        parameter Modelica.SIunits.Volume V "Fluid volume";
        parameter Modelica.SIunits.Pressure dp_nominal
          "Pressure drop during test";
        parameter Real VperA_flow_nominal(unit="m/s")
          "Volume flow rate per area of test flow";
        parameter Real y_intercept "F'(ta)_en from ratings data";
        parameter Real IAMDiff
          "Incident angle modifier for diffuse radiation from ratings data";
        parameter Modelica.SIunits.CoefficientOfHeatTransfer C1
          "Heat loss coefficient (C1) from ratings data";
        parameter Real C2(
        final unit = "W/(m2.K2)")
          "Temperature dependence of the heat losses (C2) from ratings data";
        parameter Real B0 "1st incident angle modifier coefficient";
        parameter Real B1 "2nd incident angle modifier coefficient";
        parameter Modelica.SIunits.Mass mDry "Dry weight";
        parameter Real slope(unit = "W/(m2.K)") "Slope from rating data";
        annotation (defaultComponentName="gas", Documentation(info="<html>
Generic record for solar information from SRCC certified solar collectors. This generic record is intended for concentrating solar collectors using data collected according to EN12975.
The implementation is according to 
<a href=\"http://www.solar-rating.org/ratings/og100.html\">SRCC OG-100 Directory, 
SRCC Certified Solar Collecotr Ratings</a>.
</html>",       revisions="<html>
<ul>
<li>
Feb 28, 2013, by Peter Grant:<br>
First implementation.
</li>
</ul>
</html>"));
      end Generic;

      record SRCC2011127A =
        Buildings.Fluid.SolarCollectors.Data.Concentrating.Generic (
          ATyp=Types.Area.Aperture,
          Fluid=Types.DesignFluid.Water,
          A=3.364,
          dp_nominal=1069*1000,
          V=4.4/1000,
          VperA_flow_nominal=24.1/(10^6),
          y_intercept=0.720,
          IAMDiff=0.133,
          C1=2.8312,
          C2=0.00119,
          B0=0,
          B1=0,
          mDry=484,
          slope=0) "Cogenra Solar, SunDeck"
          annotation(Documentation(info = "<html>
    <h4>Citation</h4>
    <p>
    Ratings data taken from the Solar Rating Certification Corporation website. SRCC# = 2011127A.<br>
    </p>
    </html>"));
    end Concentrating;

    record PartialSolarCollector

      parameter Buildings.Fluid.SolarCollectors.Types.Area ATyp
        "Gross or aperture area";
      parameter Buildings.Fluid.SolarCollectors.Types.DesignFluid Fluid
        "Design fluid - Water or air";
      parameter Modelica.SIunits.Area A "Area";
      parameter Modelica.SIunits.Mass mDry "Dry weight";
      parameter Modelica.SIunits.Volume V "Fluid volume";
      parameter Modelica.SIunits.Pressure dp_nominal
        "Pressure drop during test";
      parameter Real VperA_flow_nominal(unit="m/s")
        "Volume flow rate per area of test flow";
       parameter Real B0 "1st incident angle modifier coefficient";
       parameter Real B1 "2nd incident angle modifier coefficient";
       parameter Real y_intercept "Y intercept (Maximum efficiency)";
       parameter Real slope(unit = "W/(m2.K)") "Slope from rating data";
       parameter Real IAMDiff
        "Incidence angle modifier from EN12975 ratings data";
       parameter Real C1 "Heat loss coefficient from EN12974 ratings data";
       parameter Real C2
        "Temperature dependance of heat loss from EN12975 ratings data";
    annotation(Documentation(info="<html>
Partial data file which is used for the <a href=\"modelica://Buildings.Fluid.SolarCollectors.BaseClasses.PartialSolarCollector\">Buildings.Fluid.Solarcollectors.BaseClasses.PartialSolarCollector</a>
model.</html>"));
    end PartialSolarCollector;
  annotation (Documentation(info="<html>
Package with performance data of solar thermal collectors.
</html>"));
  end Data;

  package BaseClasses "Package with base classes for Buildings.Solar"
  extends Modelica.Icons.BasesPackage;

    model PartialSolarCollector "Partial model for solar collectors"
     extends Buildings.Fluid.Interfaces.LumpedVolumeDeclarations;
      extends Buildings.Fluid.Interfaces.TwoPortFlowResistanceParameters(dp_nominal = perPar.dp_nominal);
      extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
        showDesignFlowDirection=false,
        m_flow_nominal=1000*perPar.VperA_flow_nominal*perPar.A,
        final show_T=true);
      parameter Integer nSeg(min=3) = 3
        "Number of segments to be used in the simulation";

      parameter Modelica.SIunits.Angle lat "Latitude";
      parameter Modelica.SIunits.Angle azi "Surface azimuth";
      parameter Modelica.SIunits.Angle til "Surface tilt";
      parameter Modelica.SIunits.HeatCapacity C=385*perPar.mDry
        "Heat capacity of solar collector without fluid (cp_copper*mDry)";
      parameter Real shaCoe(
        min=0.0,
        max=1.0) = 0 "shading coefficient 0.0: no shading, 1.0: full shading";
      Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heaCap[nSeg](each C=C/
            nSeg) if
         not (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)
        "Heat capacity for one segment of the the solar collector"
        annotation (Placement(transformation(extent={{-40,-44},{-20,-24}})));
      BoundaryConditions.WeatherData.Bus weaBus "Weather data bus" annotation (Placement(
            transformation(extent={{-110,68},{-90,88}}), iconTransformation(extent=
                {{16,90},{36,110}})));
      BoundaryConditions.SolarIrradiation.DiffusePerez     HDifTilIso(
        final outSkyCon=true,
        final outGroCon=true,
        final til=til,
        final lat=lat,
        final azi=azi) annotation (Placement(transformation(extent={{-80,72},{-60,92}})));
      BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil(
        til=til,
        lat=lat,
        azi=azi) annotation (Placement(transformation(extent={{-80,46},{-60,66}})));
      parameter Modelica.SIunits.Temperature TEnv_nominal
        "Outside air temperature"
        annotation(Dialog(group="Nominal condition"));
      parameter Modelica.SIunits.Irradiance I_nominal
        "Irradiance at nominal condition"
        annotation(Dialog(group="Nominal condition"));
      parameter Modelica.SIunits.SpecificHeatCapacity Cp
        "Specific heat capacity of the fluid"
        annotation(group="Nominal condition");
    protected
      parameter Medium.ThermodynamicState sta_nominal=Medium.setState_pTX(
          T=Medium.T_default,
          p=Medium.p_default,
          X=Medium.X_default);
      parameter Modelica.SIunits.Density rho=if perPar.Fluid >Types.DesignFluid.Air                                 then 1000 else 1.225
        "Density, used to compute mass flow rate";
      parameter Buildings.Fluid.SolarCollectors.Data.PartialSolarCollector perPar
        "Partial performance data"
        annotation(choicesAllMatching=true);

    public
      Sensors.MassFlowRate senMasFlo(redeclare package Medium = Medium)
        annotation (Placement(transformation(extent={{-80,-11},{-60,11}})));
      FixedResistances.FixedResistanceDpM                 res(
        redeclare final package Medium = Medium,
        final from_dp=from_dp,
        final show_T=show_T,
        final m_flow_nominal=m_flow_nominal,
        final dp_nominal=dp_nominal,
        final allowFlowReversal=allowFlowReversal,
        final show_V_flow=show_V_flow,
        final linearized=linearizeFlowResistance,
        final homotopyInitialization=homotopyInitialization,
        use_dh=false) "Flow resistance"
                                     annotation (Placement(transformation(extent={{-50,-10},
                {-30,10}}, rotation=0)));
      MixingVolumes.MixingVolume vol[nSeg](
        each nPorts=2,
        redeclare package Medium = Medium,
        each m_flow_nominal=m_flow_nominal,
        each V=perPar.V,
        each energyDynamics=energyDynamics,
        each p_start=p_start,
        each T_start=T_start) annotation (Placement(transformation(
            extent={{10,-10},{-10,10}},
            rotation=180,
            origin={48,-16})));
      Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temSen[nSeg]
        "Temperature sensor"
              annotation (Placement(transformation(
            extent={{-10,10},{10,-10}},
            rotation=180,
            origin={6,-16})));
      HeatTransfer.Sources.PrescribedHeatFlow QLos[nSeg]
        annotation (Placement(transformation(extent={{38,20},{58,40}})));
      HeatTransfer.Sources.PrescribedHeatFlow heaGai[nSeg]
        annotation (Placement(transformation(extent={{38,60},{58,80}})));
    equation
      connect(weaBus, HDifTilIso.weaBus) annotation (Line(
          points={{-100,78},{-88,78},{-88,82},{-80,82}},
          color={255,204,51},
          thickness=0.5,
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}}));
      connect(weaBus, HDirTil.weaBus) annotation (Line(
          points={{-100,78},{-88,78},{-88,56},{-80,56}},
          color={255,204,51},
          thickness=0.5,
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}}));
      connect(port_a, senMasFlo.port_a) annotation (Line(
          points={{-100,0},{-80,0}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(senMasFlo.port_b, res.port_a) annotation (Line(
          points={{-60,0},{-50,0}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(heaCap.port, vol.heatPort) annotation (Line(
          points={{-30,-44},{30,-44},{30,-16},{38,-16}},
          color={191,0,0},
          smooth=Smooth.None));
          connect(vol[nSeg].ports[2], port_b) annotation (Line(
          points={{50,-6},{50,0},{100,0}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(vol[1].ports[1], res.port_b) annotation (Line(
          points={{46,-6},{46,0},{-30,0}},
          color={0,127,255},
          smooth=Smooth.None));
          for i in 1:(nSeg - 1) loop
        connect(vol[i].ports[2], vol[i + 1].ports[1]);
      end for;
      connect(vol.heatPort, temSen.port)            annotation (Line(
          points={{38,-16},{16,-16}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(QLos.port, vol.heatPort)    annotation (Line(
          points={{58,30},{76,30},{76,-44},{30,-44},{30,-16},{38,-16}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(heaGai.port, vol.heatPort)   annotation (Line(
          points={{58,70},{76,70},{76,-44},{30,-44},{30,-16},{38,-16}},
          color={191,0,0},
          smooth=Smooth.None));
      annotation (
        Diagram(graphics),
        Icon(graphics={
            Rectangle(
              extent={{-86,100},{88,-100}},
              lineColor={215,215,215},
              fillColor={215,215,215},
              fillPattern=FillPattern.Solid),
            Rectangle(
              extent={{-10,80},{10,-100}},
              lineColor={215,215,215},
              fillColor={135,135,135},
              fillPattern=FillPattern.Solid),
            Rectangle(
              extent={{30,80},{50,-100}},
              lineColor={215,215,215},
              fillColor={135,135,135},
              fillPattern=FillPattern.Solid),
            Rectangle(
              extent={{-50,80},{-28,-100}},
              lineColor={215,215,215},
              fillColor={135,135,135},
              fillPattern=FillPattern.Solid),
            Rectangle(
              extent={{-60,100},{60,80}},
              lineColor={215,215,215},
              fillColor={135,135,135},
              fillPattern=FillPattern.Solid),
            Ellipse(
              extent={{-24,28},{28,-24}},
              lineColor={255,0,0},
              fillColor={255,0,0},
              fillPattern=FillPattern.Solid),
            Line(
              points={{-48,2},{-28,2}},
              color={255,0,0},
              smooth=Smooth.None,
              thickness=1),
            Line(
              points={{34,2},{54,2}},
              color={255,0,0},
              smooth=Smooth.None,
              thickness=1),
            Line(
              points={{-8,-8},{6,6}},
              color={255,0,0},
              smooth=Smooth.None,
              thickness=1,
              origin={30,34},
              rotation=180),
            Line(
              points={{-34,-38},{-18,-22}},
              color={255,0,0},
              smooth=Smooth.None,
              thickness=1),
            Line(
              points={{-8,-8},{6,6}},
              color={255,0,0},
              smooth=Smooth.None,
              thickness=1,
              origin={32,-28},
              rotation=90),
            Line(
              points={{-6,-6},{8,8}},
              color={255,0,0},
              smooth=Smooth.None,
              thickness=1,
              origin={-22,32},
              rotation=90),
            Line(
              points={{-10,0},{10,0}},
              color={255,0,0},
              smooth=Smooth.None,
              thickness=1,
              origin={4,-38},
              rotation=90),
            Line(
              points={{-10,0},{10,0}},
              color={255,0,0},
              smooth=Smooth.None,
              thickness=1,
              origin={2,42},
              rotation=90)}),
        defaultComponentName="solCol",
        Documentation(info="<html>
<p>
This component is a partial model of a solar thermal collector. It can be expanded to create solar collectors models based on either ASHRAE93 or EN12975 ratings data.
</p>
<h4>Notice</h4>
<p>
1. As metioned in the reference, the SRCC incident angle modifier equation coefficients are only valid for incident angles of 60 degrees or less.
Because these curves can be valid yet behave poorly for angles greater than 60 degrees, the model cuts off collectors' gains of both direct and diffuse solar radiation for incident angles greater than 60 degrees. 
<br>
2. By default, the esitimated heat capacity of the collector without fluid is calculated based on the dry mass and the specific heat capacity of copper.
</p>
<h4>References</h4>
<p>
<a href=\"http://www.energyplus.gov\">EnergyPlus 7.0.0 Engineering Reference</a>, October 13, 2011.
<br>
J.A. Duffie and W.A. Beckman 2006, Solar Engineering of Thermal Processes (3rd Edition), John Wiley & Sons, Inc.  
</p>
</html>",     revisions="<html>
<ul>
<li>
January 4, 2013, by Peter Grant:<br>
First implementation.
</li>
</ul>
</html>"));
    end PartialSolarCollector;

    block ASHRAESolarGain
      "Calculate the solar heat gain of a solar collector per ASHRAE Standard 93"
      extends Modelica.Blocks.Interfaces.BlockIcon;
      extends Buildings.Fluid.SolarCollectors.BaseClasses.PartialParameters;
      Modelica.Blocks.Interfaces.RealInput HSkyDifTil(quantity=
            "RadiantEnergyFluenceRate", unit="W/m2")
        "Diffuse solar irradiation on a tilted surfce from the sky"
        annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
      Modelica.Blocks.Interfaces.RealInput HGroDifTil(quantity=
            "RadiantEnergyFluenceRate", unit="W/m2")
        "Diffuse solar irradiation on a tilted surfce from the ground"
        annotation (Placement(transformation(extent={{-140,28},{-100,68}})));
      Modelica.Blocks.Interfaces.RealInput incAng(
        quantity="Angle",
        unit="rad",
        displayUnit="degree")
        "Incidence angle of the sun beam on a tilted surface"
        annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
      Modelica.Blocks.Interfaces.RealInput HDirTil(quantity=
            "RadiantEnergyFluenceRate", unit="W/m2")
        "Direct solar irradiation on a tilted surfce"
        annotation (Placement(transformation(extent={{-140,0},{-100,40}})));
      Modelica.Blocks.Interfaces.RealOutput QSol_flow[nSeg](final unit="W")
        "Solar heat gain"
        annotation (Placement(transformation(extent={{100,-10},{120,10}})));
      parameter Real B0 "1st incident angle modifer coefficient";
      parameter Real B1 "2nd incident angle modifer coefficient";
      parameter Real shaCoe(
        min=0.0,
        max=1.0) = 0 "Shading coefficient 0.0: no shading, 1.0: full shading";
      parameter Modelica.SIunits.Angle til "Surface tilt";
    protected
      final parameter Real iamSky( fixed = false)
        "Incident angle modifier for diffuse solar radiation from the sky";
      final parameter Real iamGro( fixed = false)
        "Incident angle modifier for diffuse solar radiation from the ground";
      Real iamBea "Incident angle modifier for director solar radiation";
      Real iam "weighted incident angle modifier";
      final parameter Modelica.SIunits.Angle incAngSky( fixed = false)
        "Incident angle of diffuse radiation from the sky";
      final parameter Modelica.SIunits.Angle incAngGro( fixed = false)
        "Incident angle of diffuse radiation from the ground";
      final parameter Real tilDeg(
      unit = "deg") = Modelica.SIunits.Conversions.to_deg(til)
        "Surface tilt angle in degrees";
      final parameter Modelica.SIunits.HeatFlux HTotMin = 1
        "Minimum HTot to avoid div/0";
      final parameter Real HMinDel = 0.001
        "Delta of the smoothing function for HTot";
    initial equation
      // E+ Equ (557)
      incAngSky = Modelica.SIunits.Conversions.from_deg(59.68 - 0.1388*(tilDeg) + 0.001497*(tilDeg)^2);
      // Diffuse radiation from the sky
      // E+ Equ (555)
      iamSky = Buildings.Fluid.SolarCollectors.BaseClasses.IAM(
            incAngSky,
            B0,
            B1);
      // E+ Equ (558)
      incAngGro = Modelica.SIunits.Conversions.from_deg(90 - 0.5788*(tilDeg)+0.002693*(tilDeg)^2);
      // Diffuse radiation from the ground
      // E+ Equ (555)
      iamGro = Buildings.Fluid.SolarCollectors.BaseClasses.IAM(
            incAngGro,
            B0,
            B1);
    equation
      // E+ Equ (555)
      iamBea = Buildings.Utilities.Math.Functions.smoothHeaviside(1/3*Modelica.Constants.pi
         - incAng, Modelica.Constants.pi/60)*
        Buildings.Fluid.SolarCollectors.BaseClasses.IAM(
            incAng,
            B0,
            B1);
      // E+ Equ (556)
      iam = Buildings.Utilities.Math.Functions.smoothHeaviside(
          1/3*Modelica.Constants.pi-incAng,Modelica.Constants.pi/60)*((HDirTil*iamBea + HSkyDifTil*iamSky + HGroDifTil*iamGro)/
          Buildings.Utilities.Math.Functions.smoothMax((HDirTil + HSkyDifTil + HGroDifTil), HTotMin, HMinDel));
      // Modified from EnergyPlus Equ (559) by applying shade effect for direct solar radiation
      // Only solar heat gain is considered here
      for i in 1 : nSeg loop
        QSol_flow[i] = A_c/nSeg*(y_intercept*iam*(HDirTil*(1.0 - shaCoe) + HSkyDifTil + HGroDifTil));
      end for;

      annotation (
        defaultComponentName="solHeaGai",
        Documentation(info="<html>
<p>
This component computes the solar heat gain of thesolar thermal collector. It only calculates the solar heat gain without considering the heat loss to the evironment. This model uses ratings data according to ASHRAE93.
The solar heat gain is calculated using Equations 555 - 559 in the referenced E+ documentation.
</p>
<h4>Equations</h4>
<p>
The solar radiation absorbed by the panel is identified using Eq 559 from the E+ documentation. It is:
</p>
<p align=\"center\" style=\"font-style:italic;\">
Q<sub>Flow</sub>[i]=A<sub>c</sub>/nSeg * (F<sub>R</sub>(&tau;&alpha;)*K<sub>(&tau;&alpha;)<sub>net</sub></sub>*(G<sub>Dir</sub>*(1-P<sub>sha</sub>)+G<sub>Dif,Sky</sub>+G<sub>Dif,Gnd</sub>))
</p>
The solar radiation equation indicates that the collector is divided into multiple segments. The number of segments used in the simulation is specified by the user (variable: nSeg).
The area of an individual segment is identified by dividing the collector area by the total number of segments. The term P<sub>sha</sub> is used to define the percentage of the collector which is shaded.
</p>
<p>
The incidence angle modifier used in the solar radiation equation is found using Eq 556 from the E+ documentation. It is:
</p>
<p align=\"center\" style=\"font-style:italic;\">
K<sub>(&tau;&alpha;),net</sub>=(G<sub>beam</sub>*K<sub>(&tau;&alpha;),beam</sub>+G<sub>sky</sub>*K<sub>(&tau;&alpha;),sky</sub>+G<sub>gnd</sub>*K<sub>(&tau;&alpha;),gnd</sub>) / (G<sub>beam</sub>+G<sub>sky</sub>+G<sub>gnd</sub>)
</p>
<p>
Each incidence angle modifier is calculated using Eq 555 from the E+ documentation. It is:
</p>
<p align=\"center\" style=\"font-style:italic;\">
  K<sub>(&tau;&alpha;),x</sub>=1+b<sub>0</sub>*(1/cos(&theta;)-1)+b<sub>1</sub>*(1/cos(&theta;)-1)^2
</p>
Theta is the incidence angle. For beam radiation theta is found via standard geometry. The incidence angle for sky and ground diffuse radiation are found using, respectively, Eq 557 and 558 from the E+ documentation. They are:
</p>
<p align=\"center\" style=\"font-style:italic;\">
Theta<sub>sky</sub>=59.68-0.1388*tilt+0.001497*tilt^2<br>
Theta<sub>gnd</sub>=90.0-0.5788*tilt+0.002693*tilt^2
</p>
<p>
These two equations must be evaluated in degrees. The necessary unit conversions are made internally, and the user does not need to worry about it. Tilt is the surface tilt of the collector.
</p>

<h4>References</h4>
<p>
<a href=\"http://www.energyplus.gov\">EnergyPlus 7.0.0 Engineering Reference</a>, October 13, 2011.
</p>
</html>",     revisions="<html>
<ul>
<li>
Jan 15, 2013, by Peter Grant:<br>
First implementation
</li>
</ul>
</html>"),
        Diagram(graphics),
        Icon(graphics={Text(
              extent={{-48,-32},{36,-66}},
              lineColor={0,0,255},
              textString="%name")}));
    end ASHRAESolarGain;

    model EN12975SolarGain
      "Model calculating solar gains per the EN12975 standard"
      extends Modelica.Blocks.Interfaces.BlockIcon;
      extends Buildings.Fluid.SolarCollectors.BaseClasses.PartialParameters;
      Modelica.Blocks.Interfaces.RealInput HSkyDifTil(quantity=
            "RadiantEnergyFluenceRate", unit="W/m2")
        "Diffuse solar irradiation on a tilted surfce from the sky"
        annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
      Modelica.Blocks.Interfaces.RealInput incAng(
        quantity="Angle",
        unit="rad",
        displayUnit="degree")
        "Incidence angle of the sun beam on a tilted surface"
        annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
      Modelica.Blocks.Interfaces.RealInput HDirTil(quantity=
            "RadiantEnergyFluenceRate", unit="W/m2")
        "Direct solar irradiation on a tilted surfce"
        annotation (Placement(transformation(extent={{-140,0},{-100,40}})));
      Modelica.Blocks.Interfaces.RealOutput QSol_flow[nSeg](final unit="W")
        "Solar heat gain"
        annotation (Placement(transformation(extent={{100,-10},{120,10}})));
      parameter Real B0 "1st incident angle modifer coefficient";
      parameter Real B1 "2nd incident angle modifer coefficient";
      parameter Real shaCoe(
        min=0.0,
        max=1.0) = 0 "Shading coefficient 0.0: no shading, 1.0: full shading";
      parameter Modelica.SIunits.Angle til "Surface tilt";
      parameter Real iamDiff "Incidence angle modifier for diffuse radiation";
    protected
      Real iamBea "Incidence angle modifier for director solar radiation";
    equation
      // E+ Equ (555)
      iamBea = Buildings.Utilities.Math.Functions.smoothHeaviside(x=Modelica.Constants.pi
        /3 - incAng, delta=Modelica.Constants.pi/60)*
        Buildings.Fluid.SolarCollectors.BaseClasses.IAM(
            incAng,
            B0,
            B1);
      // Modified from EnergyPlus Equ (559) by applying shade effect for direct solar radiation
      // Only solar heat gain is considered here
      for i in 1 : nSeg loop
      QSol_flow[i] = A_c/nSeg*(y_intercept*(iamBea*HDirTil*(1.0 - shaCoe) + iamDiff * HSkyDifTil));
      end for;
      annotation (
        defaultComponentName="solHeaGai",
        Documentation(info="<html>
<p>
This component computes the solar heat gain of the solar thermal collector. It only calculates the solar heat gain without considering the heat loss to the evironment. This model performs calculations using ratings data from EN12975.
The solar heat gain is calculated using Equations 555 - 559 in the referenced E+ documentation. The calculation is modified somewhat to use coefficients from EN12975.
<h4> Equations</h4>
<p>
The final equation to calculate solar gain is a modified version of EQ 559 from the E+ documentation. It is:
</p>
<p align=\"center\" style=\"font-style:italic;\">
Q<sub>flow</sub>[i] = A<sub>c</sub>/nSeg * F<sub>R</sub>(&tau;&alpha;)*(K<sub>(&tau;&alpha;),beam</sub>*G<sub>bea</sub>*(1-P<sub>sha</sub>)+K<sub>Diff</sub>*G<sub>sky</sub>)
</p>
<p>
The solar radiation equation indicates that the collector is divided into multiple segments. The number of segments used in the simulation is specified by the user parameter <code>nSeg</code>.
The area of an individual segment is identified by dividing the collector area by the total number of segments. The term P<sub>sha</sub> is used to define the percentage of the collector which is shaded.
The main difference between this model and the ASHRAE model is the handling of diffuse radiation. The ASHRAE model contains calculated incidence angle modifiers for both sky and ground diffuse radiation while
this model uses a coefficient from test data to for diffuse radiation.
</p>

<h4>References</h4>
<p>
<a href=\"http://www.energyplus.gov\">EnergyPlus 7.0.0 Engineering Reference</a>, October 13, 2011.
</p>
</html>",     revisions="<html>
<ul>
<li>
Jan 15, 2013, by Peter Grant:<br>
First implementation
</li>
</ul>
</html>"),
        Diagram(graphics),
        Icon(graphics={Text(
              extent={{-48,-32},{36,-66}},
              lineColor={0,0,255},
              textString="%name")}));
    end EN12975SolarGain;

    block ASHRAEHeatLoss
      "Calculate the heat loss of a solar collector per ASHRAE standard 93"
      extends Modelica.Blocks.Interfaces.BlockIcon;
      extends Buildings.Fluid.SolarCollectors.BaseClasses.PartialParameters;
      Modelica.Blocks.Interfaces.RealInput TEnv(
        quantity="Temperature",
        unit="K",
        displayUnit="degC") "Temperature of environment"
        annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
      parameter Integer nSeg(min=3) = 3
        "Number of segments in the collector model";
    public
      Modelica.Blocks.Interfaces.RealInput TFlu[nSeg](
        quantity="Temperature",
        unit = "K",
        displayUnit="degC") "Temperature of the heat transfer fluid"
        annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
      Modelica.Blocks.Interfaces.RealOutput QLos[nSeg](
        quantity = "HeatFlowRate",
        unit = "W",
        displayUnit="W")
        "Rate at which heat is lost to ambient from a given segment at current conditions"
        annotation (Placement(transformation(extent={{100,-10},{120,10}})));
      parameter Modelica.SIunits.CoefficientOfHeatTransfer slope
        "slope from ratings data";
      parameter Modelica.SIunits.Irradiance I_nominal
        "Irradiance at nominal conditions"
        annotation(Dialog(group="Nominal condition"));
      parameter Modelica.SIunits.Temperature TIn_nominal
        "Inlet temperature at nominal conditions"
        annotation(Dialog(group="Nominal condition"));
      parameter Modelica.SIunits.Temperature TEnv_nominal
        "Ambient temperature at nomincal conditions"
        annotation(Dialog(group="Nominal condition"));
      parameter Modelica.SIunits.MassFlowRate m_flow_nominal
        "Fluid flow rate at nominal conditions"
        annotation(Dialog(group="Nominal condition"));
      parameter Modelica.SIunits.SpecificHeatCapacity Cp
        "Specific heat capacity of the fluid";
    protected
      final parameter Modelica.SIunits.HeatFlowRate QUse_nominal(fixed = false)
        "Useful heat gain at nominal conditions";
      final parameter Modelica.SIunits.HeatFlowRate QLos_nominal(fixed = false)
        "Heat loss at nominal conditions";
      final parameter Modelica.SIunits.HeatFlowRate QLosUA[nSeg](fixed = false)
        "Heat loss at current conditions";
      final parameter Modelica.SIunits.Temperature TFlu_nominal[nSeg](each start = 293.15, fixed = false)
        "Temperature of each semgent in the collector at nominal conditions";
      final parameter Modelica.SIunits.ThermalConductance UA(start = -slope*A_c, fixed = false)
        "Coefficient describing heat loss to ambient conditions";
    initial equation
      //Identifies QUse at nominal conditions
      QUse_nominal = I_nominal * A_c * y_intercept +slope * A_c *  (TIn_nominal - TEnv_nominal);
      //Identifies TFlu[nSeg] at nominal conditions
      m_flow_nominal * Cp * (TFlu_nominal[nSeg] - TIn_nominal) = QUse_nominal;
      //Identifies QLost at nominal conditions
      QLos_nominal = -slope * A_c * (TIn_nominal - TEnv_nominal);
       //Governing equation for the first segment (i=1)
       I_nominal * y_intercept * A_c/nSeg - UA/nSeg * (TIn_nominal - TEnv_nominal) = m_flow_nominal * Cp * (TFlu_nominal[1] - TIn_nominal);
       //Loop with the governing equations for segments 2:nSeg-1
       for i in 2:nSeg-1 loop
         I_nominal * y_intercept * A_c/nSeg - UA/nSeg * (TFlu_nominal[i-1] - TEnv_nominal) = m_flow_nominal * Cp * (TFlu_nominal[i] - TFlu_nominal[i-1]);
       end for;
      for i in 1:nSeg loop
        nSeg * QLosUA[i] = UA * (TFlu_nominal[i] - TEnv_nominal);
      end for;
      sum(QLosUA[1:nSeg]) = QLos_nominal;
    equation
       for i in 1:nSeg loop
         -QLos[i] * nSeg = UA * (TFlu[i] - TEnv);
       end for;
      annotation (
        defaultComponentName="heaLos",
        Documentation(info="<html>
<p>
This component computes the heat loss from the flat plate solar collector to the environment. It is designed anticipating ratings data collected in accordance with ASHRAE93.
A negative QLos[i] indicates that heat is being lost to the environment.
</p>
<h4>Equations</h4>
<p>
This model calculates the heat lost from a multiple-segment model using ratings data based solely on the inlet temperature. As a resuly, the slope from the ratings data must be converted to a UA value which,
for a given number of segments, returns the same heat loss as the ratings data would at nominal conditions. The equations used to identify the UA value are shown below:
</p>
<p align=\"center\" style=\"font-style:italic;\">
Q<sub>Use,nom</sub> = I<sub>nom</sub>*A<sub>c</sub> * F<sub>R</sub>*(&tau;&alpha;) + F<sub>R</sub>U<sub>L</sub>*A<sub>c</sub>*(T<sub>In,nom</sub> - T<sub>Amb,nom</sub>)<br>
T<sub>Fluid,nom</sub>[nSeg]=T<sub>In,nom</sub>+Q<sub>Use,nom</sub>/(m<sub>flow,nom</sub>*C<sub>p</sub>)<br>
Q<sub>Los,nom</sub>=-F<sub>R</sub>U<sub>L</sub>*A<sub>c</sub>*(T<sub>In,nom</sub>-T<sub>Env,nom</sub>)<br>
T<sub>Fluid,nom</sub>[i] = T<sub>Fluid,nom</sub>[i-1] + (G<sub>nom</sub>*F<sub>R</sub>*(&tau;&alpha;) * A<sub>c</sub>/nSeg - UA/nSeg*(T<sub>Fluid,nom</sub>[i-1]-T<sub>Env,nom</sub>))/(m<sub>Flow,nom</sub>*c<sub>p</sub>)<br>
Q<sub>Loss,UA</sub>=UA/nSeg * (T<sub>Fluid,nom</sub>[i]-T<sub>Env,nom</sub>)<br>
sum(Q<sub>Loss,UA</sub>[1:nSeg])=Q<sub>Loss,nom</sub>
</p>
The effective UA value is calculated at the beginning of the simulation and used as a constant through the rest of the simulation. The actual heat loss from the collector is calculated using:
<p align=\"center\" style=\"font-style:italic;\">
-Q<sub>Loss</sub>[i] = UA/nSeg * (T<sub>Fluid</sub>[i] - T<sub>Env</sub>)
</p>

<h4>References</h4>
<p>
J.A. Duffie and W.A. Beckman 2006, Solar Engineering of Thermal Processes (3rd Edition), John Wiley & Sons, Inc.  
</p>
</html>",     revisions="<html>
<ul>
<li>
Jan 16, 2012, by Peter Grant:<br>
First implementation
</li>
</ul>
</html>"),
        Diagram(graphics),
        Icon(graphics={Text(
              extent={{-48,-32},{36,-66}},
              lineColor={0,0,255},
              textString="%name")}));
    end ASHRAEHeatLoss;

    block EN12975HeatLoss
      "Calculate the heat loss of a solar collector per EN12975"
      extends Modelica.Blocks.Interfaces.BlockIcon;
      extends Buildings.Fluid.SolarCollectors.BaseClasses.PartialParameters;
      Modelica.Blocks.Interfaces.RealInput TEnv(
        quantity="Temperature",
        unit="K",
        displayUnit="degC") "Temperature of environment"
        annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
      parameter Integer nSeg(min=3) = 3
        "Number of segments in the collector model";
    public
      Modelica.Blocks.Interfaces.RealInput TFlu[nSeg](
        quantity="Temperature",
        unit = "K",
        displayUnit="degC") "Temperature of the heat transfer fluid"
        annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
      Modelica.Blocks.Interfaces.RealOutput QLos[nSeg](
        quantity = "HeatFlowRate",
        unit = "W",
        displayUnit="W")
        "Rate at which heat is lost to ambient from a given segment at current conditions"
        annotation (Placement(transformation(extent={{100,-10},{120,10}})));
      parameter Modelica.SIunits.CoefficientOfHeatTransfer C1
        "C1 from ratings data";
      parameter Real C2(
      final unit = "W/(m2.K2)") "C2 from ratings data";
      parameter Modelica.SIunits.Irradiance I_nominal
        "Irradiance at nominal conditions"
        annotation(Dialog(group="Nominal condition"));
      parameter Modelica.SIunits.Temperature TMean_nominal
        "Inlet temperature at nominal conditions"
        annotation(Dialog(group="Nominal condition"));
      parameter Modelica.SIunits.Temperature TEnv_nominal
        "Ambient temperature at nomincal conditions"
        annotation(Dialog(group="Nominal condition"));
      parameter Modelica.SIunits.MassFlowRate m_flow_nominal
        "Fluid flow rate at nominal conditions"
        annotation(Dialog(group="Nominal condition"));
      parameter Modelica.SIunits.SpecificHeatCapacity Cp
        "Specific heat capacity of the fluid";
    protected
      final parameter Modelica.SIunits.HeatFlowRate QUse_nominal(fixed = false)
        "Useful heat gain at nominal conditions";
      final parameter Modelica.SIunits.HeatFlowRate QLos_nominal(fixed = false)
        "Heat loss at nominal conditions";
      final parameter Modelica.SIunits.HeatFlowRate QLosUA[nSeg](fixed = false)
        "Heat loss at current conditions";
      final parameter Modelica.SIunits.Temperature TFlu_nominal[nSeg](fixed = false)
        "Temperature of the fluid in each semgent in the collector at nominal conditions";
      final parameter Modelica.SIunits.ThermalConductance UA(fixed = false)
        "Coefficient describing heat loss to ambient conditions";
    initial equation
       //Identifies QUse at nominal conditions
       QUse_nominal = I_nominal * A_c * y_intercept -C1 * A_c *  (TMean_nominal - TEnv_nominal) - C2 * A_c * (TMean_nominal - TEnv_nominal)^2;
       //Identifies TFlu[nSeg] at nominal conditions
       m_flow_nominal * Cp * (TFlu_nominal[nSeg] - TMean_nominal) = QUse_nominal;
       //Identifies QLos at nominal conditions
       QLos_nominal = -C1 * A_c * (TMean_nominal - TEnv_nominal)-C2 * A_c * (TMean_nominal - TEnv_nominal)^2;
       //Governing equation for the first segment (i=1)
       I_nominal * y_intercept * A_c/nSeg - UA/nSeg * (TMean_nominal - TEnv_nominal) = m_flow_nominal * Cp * (TFlu_nominal[1] - TMean_nominal);
       //Loop with the governing equations for segments 2:nSeg-1
       for i in 2:nSeg-1 loop
         I_nominal * y_intercept * A_c/nSeg - UA/nSeg * (TFlu_nominal[i-1] - TEnv_nominal) = m_flow_nominal * Cp * (TFlu_nominal[i] - TFlu_nominal[i-1]);
       end for;
       for i in 1:nSeg loop
         nSeg * QLosUA[i] = UA * (TFlu_nominal[i] - TEnv_nominal);
       end for;
       sum(QLosUA) = QLos_nominal;
    equation
       for i in 1:nSeg loop
         QLos[i] * nSeg = UA * (TFlu[i] - TEnv);
       end for;
      annotation (
        defaultComponentName="heaLos",
        Documentation(info="<html>
<p>
This component computes the heat loss from the flat plate solar collector to the environment. It is designed anticipating ratings data collected in accordance with EN12975.
A negative QLos[i] indicates that heat is being lost to the environment.
</p>
<h4>Equations</h4>
<p>
This model calculates the heat lost from a multiple-segment model using ratings data based solely on the inlet temperature. As a resuly, the slope from the ratings data must be converted to a UA value which,
for a given number of segments, returns the same heat loss as the ratings data would at nominal conditions. The equations used to identify the UA value are shown below:
<p align=\"center\" style=\"font-style:italic;\">
Q<sub>Use,nom</sub> = I<sub>nom</sub>*A<sub>c</sub> * F<sub>R</sub>(&tau;&alpha;) - C<sub>1</sub>*A<sub>c</sub>*(T<sub>Mean,nom</sub> - T<sub>Env,nom</sub>)-C<sub>2</sub>*A<sub>c</sub>*(T<sub>Mean,nom</sub>-T<sub>Env,nom</sub>)^2<br>
T<sub>Fluid,nom</sub>[nSeg]=T<sub>Mean,nom</sub>+Q<sub>Use,nom</sub>/(m<sub>flow,nom</sub>*C<sub>p</sub>)<br>
Q<sub>Los,nom</sub>=-C<sub>1</sub>*A<sub>c</sub>*(T<sub>Mean,nom</sub>-T<sub>Env,nom</sub>)-C<sub>2</sub>*A<sub>c</sub>*(T<sub>Mean,nom</sub>-T<sub>Env,nom</sub>)^2<br>
T<sub>Fluid,nom</sub>[i] = T<sub>Fluid,nom</sub>[i-1] + (G<sub>nom</sub>*F<sub>R</sub>(&tau;&alpha;) * A<sub>c</sub>/nSeg - UA/nSeg*(T<sub>Fluid,nom</sub>[i-1]-T<sub>Env,nom</sub>))/(m<sub>Flow,nom</sub>*c<sub>p</sub>)<br>
Q<sub>Loss,UA</sub>=UA/nSeg * (T<sub>Fluid,nom</sub>[i]-T<sub>Env,nom</sub>)<br>
sum(Q<sub>Loss,UA</sub>[1:nSeg])=Q<sub>Loss,nom</sub>
</p>
<p>
The effective UA value is calculated at the beginning of the simulation and used as a constant through the rest of the simulation. The actual heat loss from the collector is calculated using:
</p>
<p align=\"center\" style=\"font-style:italic;\">
-Q<sub>Loss</sub>[i] = UA/nSeg * (T<sub>Fluid</sub>[i] - T<sub>Env</sub>)
</p>

<h4>References</h4>
<p>
J.A. Duffie and W.A. Beckman 2006, Solar Engineering of Thermal Processes (3rd Edition), John Wiley & Sons, Inc.  
</p>
</html>",     revisions="<html>
<ul>
<li>
Jan 16, 2012, by Peter Grant:<br>
First implementation
</li>
</ul>
</html>"),
        Diagram(graphics),
        Icon(graphics={Text(
              extent={{-48,-32},{36,-66}},
              lineColor={0,0,255},
              textString="%name")}));
    end EN12975HeatLoss;

    model GCritCalc "Model calculating the critical insolation level"
      extends Modelica.Blocks.Interfaces.BlockIcon;
      Modelica.Blocks.Interfaces.RealInput TIn(unit="K")
        "Temperature of water entering the collector"
        annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
      Modelica.Blocks.Interfaces.RealOutput GCrit(unit="W/m2")
        "Critical radiation level"
        annotation (Placement(transformation(extent={{100,-16},{132,16}})));
      Modelica.Blocks.Interfaces.RealInput TEnv(unit="K")
        "Ambient temperature at the collector"
        annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
      parameter Real slope(unit="W/(m2.K)") "Slope from ratings data";
      parameter Real y_intercept "y_intercept from ratings data";
    equation
    GCrit = -slope * (TIn - TEnv) / y_intercept;
      annotation (defaultComponentName="criSol",
      Documentation(info="<html>
   <p>
   This component calculatues the solar radiation necessary for the fluid in the collector to gain heat. 
   It is used in the model Buildings.Fluid.SolarCollector.SolarPumpController.
   </p>
   <h4>Equations</h4>
   <p>
   The critical solar radiation level is calculated using Equation 6.8.2 in the referenced text. If is:
   </p>
   <p align=\"center\" style=\"font-style:italic;\">
   G<sub>Crit</sub>=F<sub>R</sub>U<sub>L</sub>*(T<sub>In</sub>-T<sub>Env</sub>)/(F<sub>R</sub>(&tau;&alpha;))
   </p>
   <h4>References</h4>
   <p>
   J.A. Duffie and W.A. Beckman 2006, Solar Engineering of Thermal Processes (3rd Edition), John Wiley & Sons, Inc.<br>
   </p>
   </html>",
      revisions = "<html>
  <ul>
  <li>
  February 15, 2013 by Peter Grant <br>
  First implementation
  </li>
  </ul>
  </html>"));
    end GCritCalc;

    function IAM "Function for incident angle modifer"
      input Modelica.SIunits.Angle incAng "Incident angle";
      input Real B0 "1st incident angle modifer coefficient";
      input Real B1 "2nd incident angle modifer coefficient";
      output Real incAngMod "Incident angle modifier coefficient";
      parameter Modelica.SIunits.Angle incAngMin = Modelica.Constants.pi / 2 -0.1
        "Minimum incidence angle to avoid /0";
      parameter Real delta = 0.0001 "Width of the smoothing function";
    algorithm
      // E+ Equ (555)
      incAngMod := 1 + B0*(1/Buildings.Utilities.Math.Functions.smoothMax(Modelica.Math.cos(incAng), Modelica.Math.cos(incAngMin), delta) - 1) + B1*(1/Buildings.Utilities.Math.Functions.smoothMax(Modelica.Math.cos(incAng), Modelica.Math.cos(incAngMin), delta) - 1)^2;

      annotation (
        Documentation(info="<html>
<h4>Overview</h4>
<p>
This function computes the coefficient for incident angle modifier for the off-normal angle. It applies a quadratic correlation to calculate the coefficient. 
The parameters B0 and B1 are listed in the Directory of SRCC (Solar Rating and Certification Corporation) Certified Solar Collector Ratings.
Note: If the angle is larger than 60 degree, the output is 0. 
</p>
<h4>References</h4>
<p>
<a href=\"http://www.energyplus.gov\">EnergyPlus 7.0.0 Engineering Reference</a>, October 13, 2011.
</p>
</html>",     revisions="<html>
<ul>
<li>
May 22, 2012, by Wangda Zuo:<br>
First implementation.
</li>
</ul>
</html>"),
        Diagram(graphics),
        Icon(graphics));
    end IAM;

    partial block PartialParameters "partial model for parameters"
      parameter Modelica.SIunits.Area A_c "Area of the collector";
      parameter Integer nSeg( min = 2)=3 "Number of segments";
        parameter Real y_intercept "Y intercept (Maximum efficiency)";
      annotation(Documentation(info="<html>
  Partial parameters used in all solar collector models</html>"));
    end PartialParameters;

    package Examples
      "Collection of models that illustrate model use and test models"
    extends Modelica.Icons.ExamplesPackage;

      model ASHRAESolarGain "Example showing the use of ASHRAESolarGain"
        import Buildings;
        extends Modelica.Icons.Example;
        parameter Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate.Generic               per=
            Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate.SRCC2001002B()
          "Performance data" annotation (choicesAllMatching=true);
        inner Modelica.Fluid.System system(p_ambient=101325) annotation (Placement(
              transformation(extent={{60,60},{80,80}}, rotation=0)));
        Buildings.Fluid.SolarCollectors.BaseClasses.ASHRAESolarGain   solHeaGai(
          B0=per.B0,
          B1=per.B1,
          y_intercept=per.y_intercept,
          nSeg=3,
          A_c=per.A,
          shaCoe=0.25,
          til=0.78539816339745)
          annotation (Placement(transformation(extent={{20,-20},{40,0}})));
        Modelica.Blocks.Sources.Constant
                                     incAng(k=0.523)
          annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
        Modelica.Blocks.Sources.Constant HDirTil(k=800)
          annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
        Modelica.Blocks.Sources.Constant HGroDifTil(k=200)
          annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
        Modelica.Blocks.Sources.Constant HSkyDifTil(k=400)
          annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
      equation
        connect(incAng.y, solHeaGai.incAng) annotation (Line(
            points={{-59,-30},{-20,-30},{-20,-14},{18,-14}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(HDirTil.y, solHeaGai.HDirTil) annotation (Line(
            points={{-19,10},{-6,10},{-6,-8},{18,-8}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(HGroDifTil.y, solHeaGai.HGroDifTil) annotation (Line(
            points={{-59,30},{-2,30},{-2,-5.2},{18,-5.2}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(HSkyDifTil.y, solHeaGai.HSkyDifTil) annotation (Line(
            points={{-19,50},{8,50},{8,-2},{18,-2}},
            color={0,0,127},
            smooth=Smooth.None));
        annotation (
          Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
                  100}}), graphics),
          Documentation(info="<html>
<p>
This examples demonstrates the implementation of ASHRAESolarGain. All of the inputs are constant resulting in a very simple model and constants for the output.
</p>
</html>",       revisions="<html>
<ul>
<li>
Mat 27, 2013 by Peter Grant:<br>
First implementation.
</li>
</ul>
</html>"),__Dymola_Commands(file=
                "Resources/Scripts/Dymola/Fluid/SolarCollector/BaseClasses/Examples/ASHRAESolarGain.mos"
              "Simulate and Plot"),
          Icon(graphics));
      end ASHRAESolarGain;

      model EN12975SolarGain "Example showing the use of EN12975SolarGain"
        extends Modelica.Icons.Example;
        import Buildings;
        parameter Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate.Generic               per=
            Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate.SRCC2001002B()
          "Performance data" annotation (choicesAllMatching=true);
        inner Modelica.Fluid.System system(p_ambient=101325) annotation (Placement(
              transformation(extent={{60,60},{80,80}}, rotation=0)));
        Buildings.Fluid.SolarCollectors.BaseClasses.EN12975SolarGain  solHeaGai(
          B0=per.B0,
          B1=per.B1,
          y_intercept=per.y_intercept,
          nSeg=3,
          A_c=per.A,
          shaCoe=0.25,
          til=45,
          iamDiff=per.IAMDiff)
          annotation (Placement(transformation(extent={{20,-20},{40,0}})));
        Modelica.Blocks.Sources.Constant
                                     incAng(k=45*(2*Modelica.Constants.pi/360))
          annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
        Modelica.Blocks.Sources.Sine     HDirTil(
          freqHz=1/86400,
          offset=400,
          amplitude=300)
          annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
        Modelica.Blocks.Sources.Sine     HSkyDifTil(
          amplitude=200,
          freqHz=1/86400,
          offset=300)
          annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
      equation
        connect(incAng.y, solHeaGai.incAng) annotation (Line(
            points={{-59,-30},{-20,-30},{-20,-14},{18,-14}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(HDirTil.y, solHeaGai.HDirTil) annotation (Line(
            points={{-19,10},{-6,10},{-6,-8},{18,-8}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(HSkyDifTil.y, solHeaGai.HSkyDifTil) annotation (Line(
            points={{-19,50},{8,50},{8,-2},{18,-2}},
            color={0,0,127},
            smooth=Smooth.None));
        annotation (
          Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
                  100}}), graphics),
          Documentation(info="<html>
<p>
This examples demonstrates the implementation of EN12975SolarGain. All of the inputs are constants resulting in a very simple model and constant output.
</p>
</html>",       revisions="<html>
<ul>
<li>
Mar 27, 2013 by Peter Grant:<br>
First implementation.
</li>
</ul>
</html>"),__Dymola_Commands(file=
                "Resources/Scripts/Dymola/Fluid/SolarCollector/BaseClasses/Examples/EN12975SolarGain.mos"
              "Simulate and Plot"),
          Icon(graphics));
      end EN12975SolarGain;

      model ASHRAEHeatLoss "Example showing the use of ASHRAEHeatLoss"
        import Buildings;
        extends Modelica.Icons.Example;
        parameter Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate.Generic               per=
            Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate.SRCC2001002B()
          "Performance data" annotation (choicesAllMatching=true);
        parameter Modelica.SIunits.Density rho = 1000 "Density of water";
        inner Modelica.Fluid.System system(p_ambient=101325) annotation (Placement(
              transformation(extent={{60,60},{80,80}}, rotation=0)));
        Modelica.Blocks.Sources.Sine     TEnv(
          freqHz=0.01,
          offset=273.15 + 10,
          amplitude=7.5)
          annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
        Modelica.Blocks.Sources.Sine     T1(
          amplitude=5,
          freqHz=0.1,
          offset=273.15 + 20)
          annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
        Modelica.Blocks.Sources.Sine     T2(
          amplitude=5,
          freqHz=0.1,
          offset=273.15 + 25)
          annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
        Modelica.Blocks.Sources.Sine     T3(
          amplitude=5,
          freqHz=0.1,
          offset=273.15 + 30)
          annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
        Buildings.Fluid.SolarCollectors.BaseClasses.ASHRAEHeatLoss   heaLos(
          nSeg=3,
          I_nominal=800,
          Cp=4186,
          A_c=per.A,
          y_intercept=per.y_intercept,
          slope=per.slope,
          TIn_nominal=293.15,
          TEnv_nominal=283.15,
          m_flow_nominal=rho*per.VperA_flow_nominal*per.A)
          annotation (Placement(transformation(extent={{62,20},{82,40}})));
      equation
        connect(TEnv.y, heaLos.TEnv) annotation (Line(
            points={{-59,70},{-20,70},{-20,36},{60,36}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(T3.y, heaLos.TFlu[3]) annotation (Line(
            points={{-59,30},{-20,30},{-20,25.3333},{60,25.3333}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(T2.y, heaLos.TFlu[2]) annotation (Line(
            points={{-59,-10},{-20,-10},{-20,24},{60,24}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(T1.y, heaLos.TFlu[1]) annotation (Line(
            points={{-59,-50},{-14,-50},{-14,22.6667},{60,22.6667}},
            color={0,0,127},
            smooth=Smooth.None));
        annotation (
          Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
                  100}}), graphics),
          Documentation(info="<html>
<p>
This examples demonstrates the implementation of ASHRAEHeatLoss. All of the inputs are constants resulting in a very simple model and a constant output.
</p>
</html>",       revisions="<html>
<ul>
<li>
Mar 27, 2013 by Peter Grant:<br>
First implementation.
</li>
</ul>
</html>"),__Dymola_Commands(file=
                "Resources/Scripts/Dymola/Fluid/SolarCollector/BaseClasses/Examples/ASHRAEHeatLoss.mos"
              "Simulate and Plot"),
          Icon(graphics));
      end ASHRAEHeatLoss;

      model EN12975HeatLoss "Example showing the use of EN12975HeatLoss"
        import Buildings;
        extends Modelica.Icons.Example;
        parameter Buildings.Fluid.SolarCollectors.Data.Concentrating.Generic per=
          Buildings.Fluid.SolarCollectors.Data.Concentrating.SRCC2011127A()
          "Performance data" annotation (choicesAllMatching=true);
        Modelica.Blocks.Sources.Sine     TEnv(
          freqHz=0.01,
          offset=273.15 + 10,
          amplitude=7.5)
          annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
        Modelica.Blocks.Sources.Sine     T1(
          amplitude=5,
          freqHz=0.1,
          offset=273.15 + 20)
          annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
        Modelica.Blocks.Sources.Sine     T2(
          amplitude=5,
          freqHz=0.1,
          offset=273.15 + 25)
          annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
        Modelica.Blocks.Sources.Sine     T3(
          amplitude=5,
          freqHz=0.1,
          offset=273.15 + 30)
          annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
        Buildings.Fluid.SolarCollectors.BaseClasses.EN12975HeatLoss  heaLos(
          nSeg=3,
          A_c=2.699,
          Cp=4186,
          y_intercept=0.718,
          C1=0.733,
          C2=0.0204,
          m_flow_nominal=0.04,
          I_nominal=800,
          TMean_nominal=298.15,
          TEnv_nominal=283.15)
          annotation (Placement(transformation(extent={{62,20},{82,40}})));
        inner Modelica.Fluid.System system
          annotation (Placement(transformation(extent={{60,60},{80,80}})));
      equation
        connect(TEnv.y, heaLos.TEnv) annotation (Line(
            points={{-59,70},{-20,70},{-20,36},{60,36}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(T3.y, heaLos.TFlu[3]) annotation (Line(
            points={{-59,30},{-20,30},{-20,25.3333},{60,25.3333}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(T2.y, heaLos.TFlu[2]) annotation (Line(
            points={{-59,-10},{-20,-10},{-20,24},{60,24}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(T1.y, heaLos.TFlu[1]) annotation (Line(
            points={{-59,-50},{-14,-50},{-14,22.6667},{60,22.6667}},
            color={0,0,127},
            smooth=Smooth.None));
        annotation (
          Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
                  100}}), graphics),
          Documentation(info="<html>
<p>
This examples demonstrates the implementation of EN12975HeatLoss. All of the inputs are constants resulting in a very simple model and a constant output.
</p>
</html>",       revisions="<html>
<ul>
<li>
Mar 27, 2013 by Peter Grant:<br>
First implementation.
</li>
</ul>
</html>"),__Dymola_Commands(file=
                "Resources/Scripts/Dymola/Fluid/SolarCollector/BaseClasses/Examples/EN12975HeatLoss.mos"
              "Simulate and Plot"),
          Icon(graphics));
      end EN12975HeatLoss;

      model GCritCalc "Example showing the use of GCritCalc"
        import Buildings;
        extends Modelica.Icons.Example;
        Buildings.Fluid.SolarCollectors.BaseClasses.GCritCalc gCritCalc(
                                                                       slope=-3.764,
            y_intercept=0.602)
          annotation (Placement(transformation(extent={{-12,0},{8,20}})));
        Modelica.Blocks.Sources.Sine TEnv(
          amplitude=10,
          freqHz=0.1,
          offset=10)
          annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
        Modelica.Blocks.Sources.Sine TIn(
          amplitude=10,
          freqHz=0.01,
          offset=30)
          annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
      equation
        connect(TEnv.y, gCritCalc.TEnv) annotation (Line(
            points={{-59,30},{-40,30},{-40,16},{-14,16}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(TIn.y, gCritCalc.TIn) annotation (Line(
            points={{-59,-10},{-40,-10},{-40,4},{-14,4}},
            color={0,0,127},
            smooth=Smooth.None));
        annotation (Diagram(graphics),
        Documentation(info="<html>
  <p>
  This model provides an example of how to use the GCritCalc model.<br>
  </p>
  </html>",
        revisions="<html>
  <ul>
  <li>
  Mar 27, 2013 by Peter Grant:<br>
  First implementation
  </li>
  </ul>
  </html>"),
          Commands(file=
                "Resources/Scripts/Dymola/Fluid/SolarCollector/BaseClasses/Examples/GCritCalc.mos"
              "Simulate and Plot"));
      end GCritCalc;
    annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains examples for the use of models that can be found in <a href=\"modelica://Buildings.Fluid.SolarCollector.BaseClasses\"> Buildings.Fluid.SolarCollector.BaseClasses. 
</p>
</html>"));
    end Examples;
  annotation (preferedView="info", Documentation(info="<html>
<p>
This package contains base classes that are used to construct the models in
<a href=\"modelica://Buildings.Fluid.Storage\">Buildings.Fluid.Storage</a>.
</p>
</html>"));
  end BaseClasses;

  package Types "Package with type definitions"

    type Area = enumeration(
        Gross "Gross area",
        Aperture "Net aperture area")
      "Enumeration to define the area used in solar collector calculation"
      annotation(Documentation(info="<html>
  Enumeration used to define the different types of area measurements used in solar collector testing.</html>"));
    type DesignFluid = enumeration(
        Air "Air",
        Water "Water")
      "Enumeration to describe the fluid used in the solar collector"
      annotation(Documentation(info="<html>
  Enumeration used to define the types of fluid for which solar collectors can be designed to use.</html>"));
  annotation (preferedView="info", Documentation(info="<html>
This package contains type definitions.
</html>"));
  end Types;
end SolarCollectors;
