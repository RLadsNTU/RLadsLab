require(imager)
require(ggplot2)

TEXT_SIZE = 4

im = load.image("Lenna.png")
gim = grayscale(im)
sgim = resize(gim, 64, 64)
xy=expand.grid(1:64, 1:64)
xy$z=array(sgim)
xy$z2 = floor(xy$z * 100)
xy$z_bin = xy$z2 > 60

plot_theme = theme_classic() + 
    theme(axis.line=element_blank(), 
          axis.ticks=element_blank(), 
          axis.text=element_blank(), 
          axis.title=element_blank(),
          legend.position = "none")

png("Lenna_number.png", 1200, 1200);
p1 = ggplot(xy, aes(Var1, Var2)) + 
     geom_text(aes(label=z2), size=TEXT_SIZE) + 
     scale_y_reverse() + plot_theme
print(p1)
dev.off()

png("Lenna_grayscale.png", 1200, 1200);

p2 = ggplot(xy, aes(Var1, Var2)) + 
    geom_tile(aes(fill=z2)) + 
    geom_text(aes(label=z2, color=xy$z_bin), size=TEXT_SIZE) + 
    scale_color_manual(values=c("white", "black")) +
    scale_y_reverse() + 
    scale_fill_gradient(low="black", high="white") + 
    plot_theme
print(p2)
dev.off()

