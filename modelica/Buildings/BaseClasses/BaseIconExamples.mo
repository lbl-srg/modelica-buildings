partial class BaseIconExamples "Icon for Examples packages" 
  
  annotation (Coordsys(
      extent=[-100, -100; 100, 100],
      grid=[1, 1],
      component=[20, 20]), Icon(
      Rectangle(extent=[-100, -100; 80, 50], style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=51,
          rgbfillColor={255,255,170},
          fillPattern=1)),
      Polygon(points=[-100, 50; -80, 70; 100, 70; 80, 50; -100, 50], style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=9,
          rgbfillColor={179,179,119},
          fillPattern=1)),
      Polygon(points=[100, 70; 100, -80; 80, -100; 80, 50; 100, 70], style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=9,
          rgbfillColor={179,179,119})),
      Text(
        extent=[-94,15; 73,-16],
        style(color=3),
        string="Library of"),
      Text(
        extent=[-120, 122; 120, 73],
        string="%name",
        style(color=1)),
      Text(
        extent=[-92,-44; 73,-72],
        style(color=3),
        string="examples")));
  
end BaseIconExamples;
