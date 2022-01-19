//
//  ParticleArchive.swift
//  
//
//  Created by Dr. Brandon Wiley on 12/26/21.
//

import Foundation
import Gardener

public class ParticleArchive: ParticleStore
{
    public var root: ParticleStoreLens
    {
        return []
    }

    let base: URL

    public init(path: String)
    {
        self.base = URL(fileURLWithPath: path)
    }

    public func put(path: ParticleStoreLens, particle: Particle) -> Bool
    {
        var folder: URL = self.base
        var url: URL = self.base
        var lastItem: Int = 0
        for item in path
        {
            folder = url
            url = url.appendingPathComponent(item.string)
            lastItem = item
        }

        if File.exists(url.path)
        {
            // Overwrite

            do
            {
                try FileManager.default.removeItem(at: url)
            }
            catch
            {
                return false
            }

            switch particle
            {
                case .atom(let string):
                    do
                    {
                        try string.data.write(to: url)
                    }
                    catch
                    {
                        return false
                    }

                    return true

                case .compound(let array):
                    guard File.makeDirectory(atPath: url.path) else {return false}
                    for (index, subparticle) in array.enumerated()
                    {
                        let sublens = path + [index]
                        guard self.put(path: sublens, particle: subparticle) else {return false}
                    }

                    return true
            }
        }
        else
        {
            guard let files = File.contentsOfDirectory(atPath: folder.path) else {return false}
            guard files.count == lastItem - 1 else {return false}

            // Append
            switch particle
            {
                case .atom(let string):
                    do
                    {
                        try string.data.write(to: url)
                    }
                    catch
                    {
                        return false
                    }

                    return true

                case .compound(let array):
                    guard File.makeDirectory(atPath: url.path) else {return false}
                    for (index, subparticle) in array.enumerated()
                    {
                        let sublens = path + [index]
                        guard self.put(path: sublens, particle: subparticle) else {return false}
                    }

                    return true
             }
        }
    }

    func load() -> Particle?
    {
        return load(rootUrl: self.base, path: "")
    }

    func load(rootUrl: URL, path: String) -> Particle?
    {
        let url = rootUrl.appendingPathComponent(path)
        guard File.exists(url.path) else {return nil}

        if FileManager.default.isReadableFile(atPath: url.path)
        {
            // Atom
            guard let data = try? Data(contentsOf: url) else {return nil}
            return Particle.atom(data.string)
        }
        else
        {
            // Compound
            guard let files = File.contentsOfDirectory(atPath: url.path) else {return nil}

            var particles: [Particle] = []

            for index in 0..<files.count
            {
                let filename = index.string
                guard let subparticle = load(rootUrl: url, path: filename) else {return nil}
                particles.append(subparticle)
            }

            return Particle.compound(particles)
        }
    }

    public func get(path: ParticleStoreLens) -> Particle?
    {
        let strings = path.map
        {
            (int: Int) -> String in

            int.string
        }
        let path = strings.joined(separator: "/")

        return self.load(rootUrl: self.base, path: path)
    }

    public func count(path: ParticleStoreLens) -> Int
    {
        let particle = self.get(path: path)
        switch particle
        {
            case .atom(_):
                return 0
            case .compound(let particles):
                return particles.count
            case nil:
                return 0
        }
    }

    public func isAtom(path: ParticleStoreLens) -> Bool
    {
        let particle = self.get(path: path)
        switch particle
        {
            case .atom(_):
                return true
            case .compound(_):
                return false
            case nil:
                return false
        }
    }
}
