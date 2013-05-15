within Buildings.Rooms.Examples.FLeXLab.Cells.BaseClasses;
model PartialTestCell
  "Generic model of a test cell. Can be extended to create specific cells"
  //fixme - Discuss with Michael. The lack of external connections with data inputs will prevent this model from simulating. That makes this partial, correct?
  //fixme - Discuss overall organization with Michael. Intent - Partial model with minimum inputs, specific model with constructions for cell, examples with inputs
    //Inputs = shaPos, intGai, airCon, watCon, TGro. Like this structure because a) Can make new models from partial easily by adding new constructions while partial
    //contains many details and can be easily edited to maintain models b) Individual cells models can have either text file inputs, or simulations (i.e. text file
    //specifying AHU SAT and airflow or connect to an AHU model. Dislike a) Without intGai specified individual cell models are structurally singular
  //fixme - Should data input file for TGro be included in partial model? Would a user ever want to simulate differently from reading a text file?
  //fixme - Should data input file for intGai be included in partial model? Would a user ever want to simulate differently from reading a text file?
  extends Modelica.Blocks.Interfaces.BlockIcon;

  Rooms.MixedAir roo
    annotation (Placement(transformation(extent={{-20,-20},{20,20}})));
  Fluid.HeatExchangers.RadiantSlabs.SingleCircuitSlab sla(sysTyp=Buildings.Fluid.HeatExchangers.RadiantSlabs.BaseClasses.Types.SystemType.Floor)
    annotation (Placement(transformation(extent={{-18,-76},{2,-56}})));         //Gr = emissivity * A * view factor. Per pg 79 of Introduction to Cold Regions Engineering (Dean Freitag, Terry McFadden) view factor for a floor to a room = 1 (assuming no windows)
  HeatTransfer.Sources.PrescribedTemperature preT "Temperature of the ground"
                                                                   annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-4,-100})));
  HeatTransfer.Data.OpaqueConstructions.Generic slaCon(nLay=3, material={
        Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.1524,
        k=1.13,
        c=1000,
        d=1400,
        nSta=5),Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.127,
        k=0.036,
        c=1200,
        d=40),Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.2,
        k=1.8,
        c=1100,
        d=2400)}) "Construction of the slab"
    annotation (Placement(transformation(extent={{-194,-120},{-174,-100}})));
               //fixme - Don't actually know width thickness of reinforced concrete foundation (3rd layer)

  Fluid.Data.Pipes.PEX_RADTEST pipe
    annotation (Placement(transformation(extent={{-194,-98},{-174,-78}})));
                 //fixme - Is it legit to use this model for air gap (2nd layer)? Probably b/c partition wall (only care about thermal mass, not heat transfer)

  //fixme - Roof construction is completely made up. Inadequate information available, only know that insulation is R20. Currently 1/2" plywood => R20 insul => 1/2 in steel sheeting

  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam="/home/peter/FLeXLab/FLeXLab/bie/modelica/Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    annotation (Placement(transformation(extent={{-12,70},{8,90}})));

  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{176,124},{196,144}})));

equation
  connect(sla.surf_b, preT.port)                  annotation (Line(
      points={{-4,-76},{-4,-90}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(weaDat.weaBus, roo.weaBus) annotation (Line(
      points={{8,80},{17.9,80},{17.9,17.9}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,
            -150},{200,150}}),      graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-200,-150},{200,150}})),
          Documentation(info="<html>
          <p>
          This is a partial model containing the base components needed to begin construction of test cell models. The model is based on 
          <a href=\"modelica://Buildings.Rooms.MixedAir\">Buildings.Rooms.MixedAir</a> and <a href=\"modelica://Buildings.Fluid.HeatExchangers.RadiantSlabs.SingleCircuitSlab\">
          Buildings.Fluid.HeatExchangers.RadiantSlabs.SingleCircuitSlab</a>. In order to perform simulations this model must be extended and
          <ul>
          <li>
          parameters for <a href=\"modelica://Buildings.Rooms.MixedAir\">Buildings.Rooms.MixedAir</a> must be specified,
          </li>
          <li>
          parameters for <a href=\"modelica://Buildings.Fluid.HeatExchangers.RadiantSlabs.SingleCircuitSlab\">Buildings.Fluid.HeatExchangers.RadiantSlabs.SingleCircuitSlab</a>
           must be specified,
           </li>
           <li>
          values or control logic for the position of shading devices (if present must be specified),
          </li>
          <li>
          values for the internal gains must be specified,
          </li>
          <li>
          connections specifying supply air flow rate and temperature must be created (can be as a specified flow and temp, or a model of an air handling unit (AHU)),
          </li>
          <li>
          connections specifying supply chilled water flow rate and temperature must be created (can be as a specifid flow and temp, or a model of the central plant),
          </li>
          <li>
          a model for the ground temperature must be included.
          </li>
          </ul>
          </p>
          </html>",
          revisions="<html>
          <ul>
          <li>
          May 15, 2013 by Peter Grant:<br>
          First implementation
          </li>
          </ul>
          </html>"));
end PartialTestCell;
