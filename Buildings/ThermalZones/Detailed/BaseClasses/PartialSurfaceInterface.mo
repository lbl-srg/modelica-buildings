within Buildings.ThermalZones.Detailed.BaseClasses;
partial model PartialSurfaceInterface
  "Partial model that is used for infrared radiation balance"
  extends Buildings.ThermalZones.Detailed.BaseClasses.ConstructionRecords;

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a conExt[NConExt]
    "Heat port that connects to room-side surface of exterior constructions"
                              annotation (Placement(transformation(extent={{230,210},
            {250,230}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a conExtWin[NConExtWin]
    "Heat port that connects to room-side surface of exterior constructions that contain a window"
                              annotation (Placement(transformation(extent={{230,170},
            {250,190}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a conExtWinFra[NConExtWin]
    "Heat port that connects to room-side surface of window frame"
                              annotation (Placement(transformation(extent={{232,-10},
            {252,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a conPar_a[NConPar]
    "Heat port that connects to room-side surface a of partition constructions"
                              annotation (Placement(transformation(extent={{232,-70},
            {252,-50}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a conPar_b[NConPar]
    "Heat port that connects to room-side surface b of partition constructions"
                              annotation (Placement(transformation(extent={{232,
            -110},{252,-90}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a conBou[NConBou]
    "Heat port that connects to room-side surface of constructions that expose their other surface to the outside"
                              annotation (Placement(transformation(extent={{232,
            -170},{252,-150}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a conSurBou[NSurBou]
    "Heat port to surfaces of models that compute the heat conduction outside of this room"
                              annotation (Placement(transformation(extent={{231,
            -230},{251,-210}})));
protected
  final parameter String instanceName = getInstanceName() "Name of the instance";
  final parameter Modelica.Units.SI.Area AConExt[NConExt]=datConExt.A
    "Areas of exterior constructions";
  final parameter Modelica.Units.SI.Area AConExtWinOpa[NConExtWin]=datConExtWin.AOpa
    "Opaque areas of exterior construction that have a window";
  final parameter Modelica.Units.SI.Area AConExtWinGla[NConExtWin]=(1 .-
      datConExtWin.fFra) .* datConExtWin.AWin
    "Glass areas of exterior construction that have a window";
  final parameter Modelica.Units.SI.Area AConExtWinFra[NConExtWin]=datConExtWin.fFra
       .* datConExtWin.AWin
    "Frame areas of exterior construction that have a window";
  final parameter Modelica.Units.SI.Area AConPar[NConPar]=datConPar.A
    "Areas of partition constructions";
  final parameter Modelica.Units.SI.Area AConBou[NConBou]=datConBou.A
    "Areas of constructions with exterior boundary conditions exposed to outside of room model";
  final parameter Modelica.Units.SI.Area ASurBou[NSurBou]=surBou.A
    "Area of surface models of constructions that are modeled outside of this room";

protected
  function checkSurfaceAreas
    input Integer n "Number of surfaces";
    input Modelica.Units.SI.Area A[:] "Surface areas";
    input String name "Name of the surface data record, used in error message";
  algorithm
    if n == 0 then
      assert(Modelica.Math.Vectors.norm(v=A, p=1) < 1E-10,
      "Error in declaration of room model: Construction record '" +
      name +
      "' has the following areas: " +
      Modelica.Math.Vectors.toString(A) +
      "However, the room model is declared as having zero surfaces.
Check the parameters of the room model.");
    else
      for i in 1:n loop
        assert(A[i] > 0, "Error in declaration of room model: Construction record '" + name + "' has the following areas: " +
      Modelica.Math.Vectors.toString(A) +
      "However, the surface areas must be bigger than zero.
Check the parameters of the room model.");
      end for;
    end if;
  end checkSurfaceAreas;
initial algorithm
  checkSurfaceAreas(nConExt,    datConExt.A,       instanceName + ".datConExt");
  checkSurfaceAreas(nConExtWin, datConExtWin.AWin, instanceName + ".datConExtWin");
  checkSurfaceAreas(nConPar,    datConPar.A,       instanceName + ".datConPar");
  checkSurfaceAreas(nConBou,    datConBou.A,       instanceName + ".datConBou");
  checkSurfaceAreas(nSurBou,    surBou.A,          instanceName + ".surBou");
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-240,
            -240},{240,240}}),
                      graphics), Icon(coordinateSystem(preserveAspectRatio=true,
          extent={{-240,-240},{240,240}}),
                                      graphics={
        Rectangle(
          extent={{-240,240},{240,-240}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{148,206},{174,-206}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-170,-200},{172,-224}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-170,206},{-144,-224}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-170,208},{174,184}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-234,328},{242,244}},
          textColor={0,0,127},
          textString="%name"),
        Rectangle(
          extent={{-144,184},{148,-198}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid)}),
        Documentation(info="<html>
<p>
This partial model is used as a base class for models that need to exchange
heat with room-facing surfaces. It defines parameters for the surface areas.
The model is used as a base class to implement the convective model, and the various
radiation models.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 12, 2013, by Michael Wetter:<br/>
Removed the radiation related declarations
to facilitate the separation of the convective and radiative model.
</li>
<li>
July 17, 2012, by Michael Wetter:<br/>
Added validity check of surface areas.
This helped catching a bug in an early implementation of BESTEST Case960
in which the extending class set <code>nConExtWin=0</code>,
but did not set the area to zero.
Because the radiation balance model computes exchange among
<code>NConExtWin=max(nConExtWin, 1)</code> areas, its result was wrong.
</li>
<li>
November 6, 2011, by Michael Wetter:<br/>
Changed parameters that contain radiative properties from final to non-final, as
they need to be overwritten by
<a href=\"modelica://Buildings.ThermalZones.Detailed.BaseClasses.SolarRadiationExchange\">
Buildings.ThermalZones.Detailed.BaseClasses.SolarRadiationExchange</a>.
</li>
<li>
November 16 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialSurfaceInterface;
