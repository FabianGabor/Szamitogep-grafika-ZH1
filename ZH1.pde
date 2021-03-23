int bgColor = 204;
int felatloXStart;
int felatloYStart;

int countClicks = 0;
int prevMouseX, prevMouseY;

Table table;
boolean redraw = false;

void setup() {
    size(640, 480);

    felatloXStart = width /5;
    felatloYStart = height /5;
    
    table = new Table();    
    table.addColumn("x");
    table.addColumn("y");
}

void draw() {    
    drawLine(felatloXStart, felatloYStart, felatloXStart+felatloSzelesseg(), felatloYStart+felatloMagassag());

    if (table.getRowCount() > 1) {
        if (redraw) {      
            background(204);
            
            int x0 = table.getRow(0).getInt("x");
            int y0 = table.getRow(0).getInt("y");
    
            int x = table.getRow(1).getInt("x");
            int y = table.getRow(1).getInt("y");
    
            drawHex(x, y, x0, y0);            
            redraw = false;
        }        
    }
}

int felatloHossza() {
    return (int) sqrt(pow(width, 2) + pow(height, 2)) / 2;
}

int felatloSzelesseg() {    
    return width/2 + 10;
}

int felatloMagassag() {
    return height/2 + 10;
}

void drawLine(float x, float y, float x0, float y0) {
    float m;
    float i, j;

    if (x0 != x) { // nem függőleges
        m = (y0 - y) / (x0 - x);

        if (abs(m) <= 1) {
            j = (x < x0) ? y : y0;
            for (i = (x < x0) ? x : x0; i < ((x > x0) ? x : x0); i++) {
                point(i, j);
                j += m;
            }
        } else {
            i = (y < y0) ? x : x0;
            for (j = (y < y0) ? y : y0; j < ((y > y0) ? y : y0); j++) {
                point(i, j);
                i += 1/m;
            }
        }
    } else {    // függőleges
        for (j = (y < y0) ? y : y0; j < ((y > y0) ? y : y0); j++) {
            point(x, j);
        }
    }
}

void drawHex(int x1, int y1, int centerX, int centerY) {
    double r = sqrt(pow(x1-centerX,2) + pow(y1-centerY,2));
    int x2, y2, x3, y3, x4, y4, x5, y5, x6, y6;
    
    x2 = (int)(x1 + centerX + sqrt(3) * (centerY - y1) ) / 2;
    y2 = (int)(y1 + centerY + sqrt(3) * (x1 - centerX) ) / 2;
    
    x3 = (int)(x2 + centerX + sqrt(3) * (centerY - y2) ) / 2;
    y3 = (int)(y2 + centerY + sqrt(3) * (x2 - centerX) ) / 2;
    
    x4 = (int)(x3 + centerX + sqrt(3) * (centerY - y3) ) / 2;
    y4 = (int)(y3 + centerY + sqrt(3) * (x3 - centerX) ) / 2;
    
    x5 = (int)(x4 + centerX + sqrt(3) * (centerY - y4) ) / 2;
    y5 = (int)(y4 + centerY + sqrt(3) * (x4 - centerX) ) / 2;
    
    x6 = (int)(x5 + centerX + sqrt(3) * (centerY - y5) ) / 2;
    y6 = (int)(y5 + centerY + sqrt(3) * (x5 - centerX) ) / 2;
    
    drawLine(x2, y2, x1, y1);
    drawLine(x3, y3, x2, y2);
    drawLine(x4, y4, x3, y3);
    drawLine(x5, y5, x4, y4);
    drawLine(x6, y6, x5, y5);
    drawLine(x1, y1, x6, y6); 
}

void mousePressed() {
    redraw = true; 
    if (table.getRowCount() == 2) {
        table.clearRows();
    }
    TableRow newRow = table.addRow();    
    newRow.setInt("x", mouseX);
    newRow.setInt("y", mouseY);
}
