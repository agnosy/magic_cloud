# encoding: utf-8
module MagicCloud
  module Scale
    module_function

    def log(words, min, max)
      scale(words, min, max){|x| Math.log(x) / Math.log(10)}
    end

    def linear(words, min, max)
      scale(words, min, max){|x| x}
    end

    def sqrt(words, min, max)
      scale(words, min, max){|x| Math.sqrt(x)}
    end

    def custom(words, min, max, &normalizer)
      scale(words, min, max, &normalizer)
    end

    private

    module_function

    def scale(words, target_min, target_max, &normalizer)
      source_min = normalizer.call(words.map{|w| w[:font_size]}.min)
      source_max = normalizer.call(words.map{|w| w[:font_size]}.max)
      koeff = (target_max - target_min).to_f / (source_max - source_min)

      words.map{|w|
        source_size = normalizer.call(w[:font_size])
        target_size = ((source_size - source_min).to_f * koeff + target_min).to_i

        w.merge(font_size: target_size)
      }
    end
  end
end