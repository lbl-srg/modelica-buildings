within Buildings.Fluid.Storage.BaseClasses;
package Examples "Examples for BaseClasses models"
  extends Modelica.Icons.ExamplesPackage;
  model IndirectTankHeatExchanger
    "Example showing the use of IndirectTankHeatExchanger"
    extends Modelica.Icons.Example;

    package Medium = Buildings.Media.ConstantPropertyLiquidWater
      "Buildings library model for water";

    Buildings.Fluid.Storage.BaseClasses.IndirectTankHeatExchanger indTanHex(
      nSeg=3,
      CHex=50,
      Q_flow_nominal=3000,
      m_flow_nominal=3000/20/4200,
      volHexFlu=0.0004,
      dExtHex=0.01905,
      redeclare package Medium = Medium,
      redeclare package MediumHex = Medium,
      dp_nominal=10000,
      TTan_nominal=293.15,
      THex_nominal=323.15) "Heat exchanger"
                        annotation (Placement(transformation(
          extent={{-12,-17},{12,17}},
          rotation=90,
          origin={-19,8})));

    Buildings.Fluid.Sources.Boundary_pT bou1(nPorts=1, redeclare package Medium
        = Medium)
      annotation (Placement(transformation(extent={{-72,-42},{-52,-22}})));
    Buildings.Fluid.Sources.MassFlowSource_T bou(
      m_flow=0.1,
      nPorts=1,
      redeclare package Medium = Medium,
      T=323.15) annotation (Placement(transformation(extent={{-72,34},{-52,54}})));

    Buildings.HeatTransfer.Sources.FixedTemperature watTem[3](each T=293.15)
      annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=180,
          origin={30,8})));
    inner Modelica.Fluid.System system
      annotation (Placement(transformation(extent={{40,60},{60,80}})));
  equation
    connect(bou1.ports[1], indTanHex.port_a)
                                            annotation (Line(
        points={{-52,-32},{-19,-32},{-19,-4}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(bou.ports[1], indTanHex.port_b)
                                           annotation (Line(
        points={{-52,44},{-19,44},{-19,20}},
        color={0,127,255},
        smooth=Smooth.None));

    connect(watTem.port, indTanHex.port)
                                        annotation (Line(
        points={{20,8},{-7.89333,8}},
        color={191,0,0},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics),
                                  __Dymola_Commands(file=
            "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/BaseClasses/Examples/IndirectTankHeatExchanger.mos"
          "Simulate and Plot"),
          Documentation(info="<html>
        <p>
        This model provides an example of how the <a href=\"modelica://Buildings.Fluid.Storage.BaseClasses.IndirectTankHeatExchanger\"> Buildings.Fluid.Storage.BaseClasses.IndirectTankHeatExchanger</a> model is used. In the model water flows from a flow source through the heat exchanger to a low
         pressure environment. The stagnant fluid on the outside of the heat exchanger is modeled as a constant temperature.<br/>
         </p>
         </html>
        ",revisions="<html>
        <ul>
        <li>
        Mar 27, 2013 by Peter Grant:<br/>
        First implementation        
        </li>
	</ul>
        </html>"));
  end IndirectTankHeatExchanger;
  annotation(Documentation(info="<html>
  <p>
  This package contains examples for models found in <a href=\"modelica://Buildings.Fluid.Storage.BaseClasses\">
  Buildings.Fluid.Storage.BaseClasses</a>.
  </p>
  </html>"));
end Examples;
