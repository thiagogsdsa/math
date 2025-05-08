#include <opencv2/opencv.hpp>
#include <complex>

int mandelbrot(double x0, double y0, int max_iter) {
    std::complex<double> z(0, 0);
    std::complex<double> c(x0, y0);
    int iter = 0;
    while (std::abs(z) <= 2.0 && iter < max_iter) {
        z = z * z + c;
        ++iter;
    }
    return iter;
}

int main() {
    const int width = 800;
    const int height = 600;
    const int max_iter = 1000;

    cv::Mat image(height, width, CV_8UC3);

    for (int py = 0; py < height; ++py) {
        for (int px = 0; px < width; ++px) {
            double x0 = (px - width/2.0) * 4.0 / width;
            double y0 = (py - height/2.0) * 4.0 / width;

            int iter = mandelbrot(x0, y0, max_iter);

            int color = static_cast<int>(255.0 * iter / max_iter);
            image.at<cv::Vec3b>(py, px) = cv::Vec3b(0, color, color);  // azul/vermelho
        }
    }

    cv::imwrite("mandelbrot.png", image);
    return 0;
}